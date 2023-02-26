import torch.nn as nn
import torch
import argparse
import sys

residue_symbol2id={'G': 0, 'A': 1, 'S': 2, 'P': 3, 'V': 4, 'T': 5, 'C': 6, 'I': 7, 'L': 8, 'N': 9, 'D': 10, 'Q': 11, 'K': 12, 'E': 13, 'M': 14, 'H': 15, 'F': 16, 'R': 17, 'Y': 18, 'W': 19}

id2residue_symbol={0: 'G', 1: 'A', 2: 'S', 3: 'P', 4: 'V', 5: 'T', 6: 'C', 7: 'I', 8: 'L', 9: 'N', 10: 'D', 11: 'Q', 12: 'K', 13: 'E', 14: 'M', 15: 'H', 16: 'F', 17: 'R', 18: 'Y', 19: 'W'}

our_symbol2id = {"A":0, "C":1, "D":2, "E":3, "F":4, "G":5,"H":6, "I":7, "K":8, "L":9, "M":10, "N":11, "P":12, "Q":13, "R":14, "S":15, "T":16, "V":17, "W":18, "Y":19}

def map2ourid(x):
   return our_symbol2id[id2residue_symbol[x]]

class Transformer_representation_embedding(nn.Module):  # for sequence
    #model_seq = Transformer_representation_embedding(out_dim=args.out_dim,max_len=args.max_length,d_model=1024,device=args.device).to(args.device)
    
    def __init__(self,out_dim,max_len,d_model=128, nhead=4,num_layers=6):  
        super(Transformer_representation_embedding, self).__init__()
        self.embedding = nn.Embedding(20,d_model)
        self.encoder_layer = nn.TransformerEncoderLayer(d_model=d_model, nhead=nhead)
        self.num_layers=num_layers
        self.TransformerEncoder=nn.TransformerEncoder(self.encoder_layer,num_layers=self.num_layers)
        self.fc1 = nn.Linear(d_model * max_len,out_dim)
        self.fc2 = nn.Linear(out_dim,out_dim)
    
    def forward(self, x):
        
        #out = torch.max(x, dim=-1)[1] #from one hot to indices. if this embedding is better we don't need to store one hot encodings anymore
        out = self.embedding(x) #x should be IntTensor or LongTensor of arbitrary shape containing the indices to extract
        out = self.TransformerEncoder(out)
        #encoder_layer=nn.TransformerEncoderLayer(d_model=self.d_model, nhead=self.nhead)
        #out = nn.TransformerEncoder(encoder_layer,num_layers=self.num_layers)(x)
        
        #out = torch.flatten(out, 1)
        #out = self.fc1(out)
        #out = self.fc2(out)
        return out

out_dim=196
d_model=128
max_length=500
config_str="r50-d196-v7-4"  #r50-d196-2: embedding=128, head=8, layer=10, channel: 10, 20, 30

model_seq = Transformer_representation_embedding(out_dim=out_dim,max_len=max_length,d_model=d_model,nhead=8,num_layers=10)

##r50-d196-2
#checkpoint_path = str(sys.argv[1])
#parser = argparse.ArgumentParser()
#parser.add_argument("-c", "--checkpoint", type=str)
#parser.add_argument("-s", "--configstr", type=str)
#args = parser.parse_args()
#checkpoint_path = args.checkpoint
#config_str = args.configstr

#checkpoint = torch.load(f'{checkpoint_path}',map_location=lambda storage, loc: storage)
#checkpoint = torch.load('../SimCLR-master-r50-swiss-d196-v7-4/runs/Feb15_18-32-01_gvnodeb011/checkpoint_0056000.pth.tar',map_location=lambda storage, loc: storage)
checkpoint = torch.load('./checkpoint/checkpoint_0280000-r50-d196-2.pth.tar',map_location=lambda storage, loc: storage)


model_seq.load_state_dict(checkpoint['state_dict1'])

for p in model_seq.parameters():
      p.requires_grad = False

print("load model")
