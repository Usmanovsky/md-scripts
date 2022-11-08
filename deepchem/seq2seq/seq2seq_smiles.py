"""
This script trains an encoder-decoder on a list of smiles from VT-2005 and tries to predict smiles using 
their embedding vectors.
"""
import pandas as pd
import numpy as np
import deepchem as dc
from tqdm import tqdm, trange
import tensorflow as tf
#from tqdm.notebook import trange, tqdm
import matplotlib.pyplot as plt
import sys, os
from pathlib import Path
from deepchem.models.optimizers import Adam, ExponentialDecay

# Load dataset
pathway = Path()
sigma_csv = "datasets/VT_2005_sigma_smiles_cid.csv"
sigma_csv = pd.read_csv(sigma_csv)
sigma_df = pd.DataFrame(sigma_csv)
smile = sigma_df["SMILE"]
smile_list = smile.tolist()
vocab_smile = set()
index = sigma_df["Index"]
txt_file_path = "./datasets/VT-2005_Sigma_Profiles_v2"
dict_sigma = {}
counter = 0 

# create vocabulary of smiles
for x in smile_list:
    # print(x)
    for y in x:
        try:
            vocab_smile.add(y)
        except:
            continue

print(vocab_smile)
vocab_smile = list(vocab_smile)
input_tokens = sorted(vocab_smile)

# create a dictionary of indices and corresponding sigma profiles
for i in index:
    i_str = str(i)
    i_str = i_str.zfill(4)    
    for file in pathway.glob(f"{txt_file_path}/VT2005-{i_str}-PROF.txt"):        
        # print(file)
        sigma_file = pd.read_csv(file, sep='\s+', header=None)
        sigma_df = pd.DataFrame(sigma_file)
        sigma_1 = sigma_df[1]
        sigma1_np = sigma_1.to_numpy()
        dict_sigma[i_str] = list(sigma1_np)
        # print(sigma1_np)
        # print(dict_sigma)
        counter +=1

print(counter) 


# the dataset for VT-2005 index and corresponding sigma-profile
dataset_index = [key for key,val in dict_sigma.items()]
dataset_sigma = [val for key,val in dict_sigma.items()]
assert len(dataset_sigma) == len(dataset_index)  # verify that the lengths are equal

smile_sigma_dataset = list(zip(smile_list, dataset_sigma))  # a zipped list of smiles and corresponding sigma
epoch = 1000

# model_seq = dc.models.SeqToSeq(input_tokens, output_tokens, max_output_length=51, dropout=0.1)
tokens =input_tokens
train_smiles = smile_list[0:901]

def generate_sequences(epochs, train_list):
  for i in trange(epochs):
    for s in train_list:
      yield (s, s)


max_length = max(len(s) for s in train_smiles)
batch_size = 100
batches_per_epoch = len(train_smiles)/batch_size
model_seq = dc.models.SeqToSeq(tokens,
                           tokens,
                           max_length,
                           encoder_layers=2,
                           decoder_layers=2,
                           embedding_dimension=512,
                           model_dir='smiles-seq2seq',
                           batch_size=batch_size,
                           learning_rate=ExponentialDecay(0.001, 0.9, batches_per_epoch))
                           
model_seq.fit_sequences(generate_sequences(epoch,train_smiles))
n = 901
test_smile = smile_list[n:]
predicted = model_seq.predict_from_sequences(test_smile)
count = 0
for s,p in zip(test_smile, predicted):
  if ''.join(p) == s:
    count += 1
print('reproduced', count, f'of {len(test_smile)} validation SMILES strings')
