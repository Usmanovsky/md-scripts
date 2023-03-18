from collections.abc import Sequence

import torch
from torch import nn
from torch.nn import functional as F

from torchdrug import core, layers
from torchdrug.layers import functional
from torchdrug.core import Registry as R
from .ourrepresentation_util import Transformer_representation_embedding,model_seq,map2ourid,d_model


@R.register("models.ProteinConvolutionalNetwork_ourembedding")
class ProteinConvolutionalNetwork_ourembedding(nn.Module, core.Configurable):
    """
    Protein Shallow CNN proposed in `Is Transfer Learning Necessary for Protein Landscape Prediction?`_.
    
    .. _Is Transfer Learning Necessary for Protein Landscape Prediction?:
        https://arxiv.org/pdf/2011.03443.pdf
    
    Parameters:
        input_dim (int): input dimension
        hidden_dims (list of int): hidden dimensions
        kernel_size (int, optional): size of convolutional kernel
        stride (int, optional): stride of convolution
        padding (int, optional): padding added to both sides of the input
        activation (str or function, optional): activation function
        short_cut (bool, optional): use short cut or not
        concat_hidden (bool, optional): concat hidden representations from all layers as output
        readout (str, optional): readout function. Available functions are ``sum``, ``mean``, ``max`` and ``attention``.
    """
    
    def __init__(self, input_dim, hidden_dims, kernel_size=3, stride=1, padding=1,
                activation='relu', short_cut=False, concat_hidden=False, readout="max",our_representation_dim=d_model):
        super(ProteinConvolutionalNetwork_ourembedding, self).__init__()
        if not isinstance(hidden_dims, Sequence):
            hidden_dims = [hidden_dims]
        
        self.input_dim = input_dim
        self.output_dim = sum(hidden_dims) if concat_hidden else hidden_dims[-1]
        self.output_dim+=our_representation_dim
        self.dims = [input_dim] + list(hidden_dims)
        self.short_cut = short_cut
        self.concat_hidden = concat_hidden
        self.padding_id = input_dim - 1
        
        if isinstance(activation, str):
            self.activation = getattr(F, activation)
        else:
            self.activation = activation
        
        self.layers = nn.ModuleList()
        for i in range(len(self.dims) - 1):
            self.layers.append(
                nn.Conv1d(self.dims[i], self.dims[i+1], kernel_size, stride, padding)
            )
        
        if readout == "sum":
            self.readout = layers.SumReadout("residue")
        elif readout == "mean":
            self.readout = layers.MeanReadout("residue")
        elif readout == "max":
            self.readout = layers.MaxReadout("residue")
        elif readout == "attention":
            self.readout = layers.AttentionReadout(self.output_dim, "residue")
        else:
            raise ValueError("Unknown readout `%s`" % readout)
        
    def forward(self, graph, input, all_loss=None, metric=None):
        """
        Compute the residue representations and the graph representation(s).
        
        Parameters:
            graph (Protein): :math:`n` protein(s)
            input (Tensor): input node representations
            all_loss (Tensor, optional): if specified, add loss to this tensor
            metric (dict, optional): if specified, output metrics to this dict
        
        Returns:
            dict with ``residue_feature`` and ``graph_feature`` fields:
                residue representations of shape :math:`(|V_{res}|, d)`, graph representations of shape :math:`(n, d)`
        """
        
        input = graph.residue_feature.float()
        input = functional.variadic_to_padded(input, graph.num_residues, value=self.padding_id)[0]
        input_resid = graph.residue_type
        current_device = input.get_device()
        #input_resid = input_resid.apply_(map2ourid)
        if current_device !=-1:
            input_resid = torch.tensor([map2ourid(i.item()) for i in input_resid]).cuda(current_device)
        else:
            input_resid = torch.tensor([map2ourid(i.item()) for i in input_resid]).cpu()
        
        input_resid = functional.variadic_to_padded(input_resid, graph.num_residues, value=0)[0]# in Transformer_representation_embedding we used 0 for padding 
        if current_device !=-1:
            our_representation=model_seq.cuda(current_device)(input_resid)
        else:
            our_representation=model_seq(input_resid)
        
        hiddens = []
        layer_input = input
        for layer in self.layers:
            hidden = layer(layer_input.transpose(1, 2)).transpose(1, 2)
            hidden = self.activation(hidden)
            if self.short_cut and hidden.shape == layer_input.shape:
                hidden = hidden + layer_input
            hiddens.append(hidden)
            layer_input = hidden
        
        if self.concat_hidden:
            hidden = torch.cat(hiddens, dim=-1)
        else:
            hidden = hiddens[-1]
        
        #hidden_concat = torch.cat([hiddens,our_representation],dim=-1) #this was added
        #residue_feature = functional.padded_to_variadic(hidden_concat, graph.num_residues)
        residue_feature1 = functional.padded_to_variadic(hidden, graph.num_residues)
        residue_feature2 = functional.padded_to_variadic(our_representation,graph.num_residues)
        residue_feature=torch.cat([residue_feature1,residue_feature2],dim=-1)
        graph_feature = self.readout(graph, residue_feature)
        
        return {
            "graph_feature": graph_feature,
            "residue_feature": residue_feature
        }