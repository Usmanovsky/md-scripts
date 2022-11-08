import deepchem as dc
from tqdm import tqdm,trange
from deepchem.models.optimizers import Adam, ExponentialDecay

# Load the dataset
path = Path()
train_csv = path.glob("../datasets/chembl25/chembl25_train.csv")
test_csv = path.glob("../datasets/chembl25/chembl25_test.csv")
valid_csv = path.glob("../datasets/chembl25/chembl25_valid.csv")
train_dataset = pd.read_csv(train_csv.__next__())
test_dataset = pd.read_csv(test_csv.__next__())
valid_dataset = pd.read_csv(valid_csv.__next__())

train_smiles = pd.DataFrame(train_dataset)
test_smiles = pd.DataFrame(test_dataset)
valid_smiles = pd.DataFrame(valid_dataset)
train_smiles = train_smiles["SMILES"].to_numpy()
valid_smiles = valid_smiles["SMILES"].to_numpy()
test_smiles = test_smiles["SMILES"].to_numpy()

tokens = set()

def token_set(train_list: list, tokens: set):
    for s in train_list:
        tokens = tokens.union(set(c for c in s))
    return tokens

        
tokens = token_set(train_smiles, tokens)
tokens = token_set(test_smiles, tokens)
tokens = token_set(valid_smiles, tokens)
print("Total number of tokens: ", len(tokens))
tokens = sorted(list(tokens))

max_train_len = max(len(s) for s in train_smiles)
max_test_len = max(len(s) for s in test_smiles)
max_valid_len = max(len(s) for s in valid_smiles)
max_length = max(max_train_len, max_test_len, max_valid_len)
print("Longest SMILES has length: ", max_length)

# Set parameters for model
batch_size = 100
embed=256
epoch = 10
batches_per_epoch = len(train_smiles)/batch_size
model = dc.models.SeqToSeq(tokens,
                           tokens,
                           max_length,
                           encoder_layers=2,
                           decoder_layers=2,
                           embedding_dimension=embed,
                           model_dir=f"chembl25-weights_{epoch}epochs",
                           batch_size=batch_size,
                           learning_rate=ExponentialDecay(0.001, 0.9, batches_per_epoch))


def generate_sequences(epochs):
  for i in trange(epochs):
    for s in train_smiles:
      yield (s, s)

model.fit_sequences(generate_sequences(epoch))

#validation set
predicted_valid = model.predict_from_sequences(valid_smiles)
count = 0
for s,p in tqdm(zip(valid_smiles, predicted_valid)):
    if ''.join(p) == s:
        count += 1
print('reproduced', count, f'of {len(valid_smiles)} validation SMILES strings')


# test set
predicted_test = model.predict_from_sequences(test_smiles)
count = 0
for s,p in tqdm(zip(test_smiles, predicted_test)):
    if ''.join(p) == s:
        count += 1
print('reproduced', count, f'of {len(test_smiles)} test SMILES strings')
