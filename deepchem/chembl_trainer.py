import deepchem as dc
from tqdm import tqdm,trange
from deepchem.models.optimizers import Adam, ExponentialDecay

tasks, datasets, transformers = dc.molnet.load_chembl25(splitter='stratified')
train_dataset, valid_dataset, test_dataset = datasets
train_smiles = train_dataset.ids
valid_smiles = valid_dataset.ids

tokens = set()
for s in train_smiles:
  tokens = tokens.union(set(c for c in s))
tokens = sorted(list(tokens))


max_length = max(len(s) for s in train_smiles)
batch_size = 100
embed=256
batches_per_epoch = len(train_smiles)/batch_size
model = dc.models.SeqToSeq(tokens,
                           tokens,
                           max_length,
                           encoder_layers=2,
                           decoder_layers=2,
                           embedding_dimension=embed,
                           model_dir='chembl25-weights_100epochs',
                           batch_size=batch_size,
                           learning_rate=ExponentialDecay(0.001, 0.9, batches_per_epoch))


def generate_sequences(epochs):
  for i in trange(epochs):
    for s in train_smiles:
      yield (s, s)

epoch = 100
model.fit_sequences(generate_sequences(epoch))

predicted = model.predict_from_sequences(valid_smiles)
count = 0
for s,p in tqdm(zip(valid_smiles, predicted)):
  if ''.join(p) == s:
    count += 1
print('reproduced', count, f'of {len(valid_smiles)} validation SMILES strings')
