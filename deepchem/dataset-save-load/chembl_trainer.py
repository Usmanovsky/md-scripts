import deepchem as dc
#from deepchem.models.optimizers import Adam, ExponentialDecay

tasks, datasets, transformers = dc.molnet.load_chembl25(splitter='stratified')
train, valid, test = datasets
dc.utils.save_to_disk(datasets, 'chembl25_strat.joblib')
dc.utils.save_to_disk(train, 'chembl25_strat_train.joblib')
dc.utils.save_to_disk(test, 'chembl25_strat_test.joblib')
dc.utils.save_to_disk(valid, 'chembl25_strat_valid.joblib')
train_dataset = dc.utils.load_from_disk('chembl25_strat_train.joblib')
train_smiles = train_dataset.ids
valid_dataset = dc.utils.load_from_disk('chembl25_strat_valid.joblib')
valid_smiles = valid_dataset.ids
test_dataset = dc.utils.load_from_disk('chembl25_strat_test.joblib')
test_smiles = test_dataset.ids
print("Train",len(train_smiles))
print("Valid",len(valid_smiles))
print("Test",len(test_smiles))
#print(train_smiles[0:3])
