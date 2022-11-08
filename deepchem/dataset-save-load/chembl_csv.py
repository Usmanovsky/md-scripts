import deepchem as dc
import pandas as pd


# Loading SMILES from molnet
tasks, datasets, transformers = dc.molnet.load_chembl25(splitter='stratified')
train_dataset, valid_dataset, test_dataset = datasets
train_smiles = train_dataset.ids
valid_smiles = valid_dataset.ids
test_smiles = test_dataset.ids

# convert to dataframe
train_df = pd.DataFrame(train_smiles, columns=["SMILES"])
test_df = pd.DataFrame(test_smiles, columns=["SMILES"])
valid_df = pd.DataFrame(valid_smiles, columns=["SMILES"])

# save as csv
train_df.to_csv("chembl25_train.csv", index=False)
test_df.to_csv("chembl25_test.csv", index=False)
valid_df.to_csv("chembl25_valid.csv", index=False)
print("Train",len(train_smiles))
print("Valid",len(valid_smiles))
print("Test",len(test_smiles))

