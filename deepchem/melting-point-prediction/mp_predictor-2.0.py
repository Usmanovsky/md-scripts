# Run everything on LCC
import pandas as pd
import sys
import numpy as np
import deepchem as dc
from tqdm import tqdm, trange
# from tqdm.notebook import trange, tqdm
import tensorflow as tf
import matplotlib.pyplot as plt
from sklearn.metrics import mean_absolute_percentage_error


def seed_all():
    np.random.seed(123)
    tf.random.set_seed(123)


seed_all()

if __name__ == "__main__":  # Accept command line inputs for  ligpargen files only if script is called directly.

    if len(sys.argv[1]) > 1:
        csv_file = str(sys.argv[1])
    else:
        csv_file = "melting point small.csv"    

    if len(sys.argv[2]) != 0:
        epoch = int(sys.argv[2])
    else:
        epoch = 100

#epoch = 100
# Load dataset
#csv_file = 'melting point small.csv'

loader = dc.data.CSVLoader(["Melting Point"], feature_field="SMILES", featurizer=dc.feat.ConvMolFeaturizer())

dataset = loader.create_dataset(csv_file)
transformer = dc.trans.NormalizationTransformer(transform_y=True, dataset=dataset)
dataset = transformer.transform(dataset)

splitter = dc.splits.RandomSplitter()
train_set, valid_set, test_set = splitter.train_valid_test_split(dataset, frac_train=0.6, frac_test=0.2, frac_valid=0.2)

# Create the model
model_mp = dc.models.GraphConvModel(n_tasks=1, batch_size=128, mode='regression', dropout=0.2)

# Train the model
losses = []
for i in trange(epoch):
  loss = model_mp.fit(train_set, nb_epoch=1)
  losses.append(loss)

# evaluate
print("\n")
metric_mse = dc.metrics.Metric(dc.metrics.mean_squared_error)
print('Training set:', model_mp.evaluate(train_set, [metric_mse]))
print('Valid set:', model_mp.evaluate(valid_set, [metric_mse]))
print('Test set:', model_mp.evaluate(test_set, [metric_mse]))
print("\n")

metric_r2 = dc.metrics.Metric(dc.metrics.pearson_r2_score)
print("Training set:", model_mp.evaluate(train_set, [metric_r2]))
print("Valid set:", model_mp.evaluate(valid_set, [metric_r2]))
print("Test set:", model_mp.evaluate(test_set, [metric_r2]))
print("\n")

metric_rel = dc.metrics.Metric(mean_absolute_percentage_error, mode='regression')
print("Training set:", model_mp.evaluate(train_set, [metric_rel]))
print("Valid set:", model_mp.evaluate(valid_set, [metric_rel]))
print("Test set:", model_mp.evaluate(test_set, [metric_rel]))
print("\n")

epochs = [i+1 for i in range(epoch)]
fig1 = plt.figure()
fig1.set_size_inches(14, 6, forward=True)
test = fig1.add_subplot(1,1,1)
test.plot(epochs,losses, linewidth= 2.5) 
plt.xticks(weight='bold', fontsize=16)
plt.yticks(weight='bold', fontsize=16)
test.set_xlabel("Epochs", weight='bold', fontsize=20)
test.set_ylabel(r"Training Loss", weight='bold', fontsize=20)
test.set_ylim([0.3, 0.7])
fig1.savefig(f"melting point_{epoch}.png", dpi=fig1.dpi, facecolor="white")
plt.show()
