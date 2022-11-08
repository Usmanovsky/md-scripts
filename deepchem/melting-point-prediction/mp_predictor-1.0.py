# Run everything

#import pandas as pd
import numpy as np
import deepchem as dc
#from tqdm import tqdm, trange
#import tensorflow as tf
#from tqdm.notebook import trange, tqdm
import matplotlib.pyplot as plt

#!cp drive/MyDrive/melting\ point\ small.csv .
epoch = 250
# Load dataset
csv_file = 'melting point small.csv'
loader = dc.data.CSVLoader(["Melting Point"], feature_field="SMILES", featurizer=dc.feat.ConvMolFeaturizer())

dataset = loader.create_dataset(csv_file)
transformer = dc.trans.NormalizationTransformer(transform_y=True, dataset=dataset)
dataset = transformer.transform(dataset)

splitter = dc.splits.RandomSplitter()
train_set, valid_set, test_set = splitter.train_valid_test_split(dataset, frac_train=0.6, frac_test=0.2, frac_valid=0.2)

# Create the model
model_mp = dc.models.GraphConvModel(n_tasks=1, batch_size=32, mode='regression', dropout=0.2)

# Train the model
losses = []
for i in range(epoch):
  loss = model_mp.fit(train_set, nb_epoch=1)
  losses.append(loss)

# evaluate
metric_mse = dc.metrics.Metric(dc.metrics.mean_squared_error)
print('Training set score:', model_mp.evaluate(train_set, [metric_mse]))
print('Valid set score:', model_mp.evaluate(valid_set, [metric_mse]))
print('Test set score:', model_mp.evaluate(test_set, [metric_mse]))

metric_r2 = dc.metrics.Metric(dc.metrics.pearson_r2_score)
print("Training set score:", model_mp.evaluate(train_set, [metric_r2]))
print("Valid set score:", model_mp.evaluate(valid_set, [metric_r2]))
print("Test set score:", model_mp.evaluate(test_set, [metric_r2]))

epochs = [i+1 for i in range(epoch)]
fig1 = plt.figure()
fig1.set_size_inches(14, 6, forward=True)
test = fig1.add_subplot(1,1,1)
test.plot(epochs,losses, linewidth= 2.5)  # , linestyle=':'
plt.xticks(weight='bold', fontsize=16)
plt.yticks(weight='bold', fontsize=16)
test.set_xlabel("Epochs", weight='bold', fontsize=20)
test.set_ylabel(r"MSE", weight='bold', fontsize=20)
test.set_ylim([0.3, 0.7])
fig1.savefig(f"gconv_{epoch}.png", dpi=fig1.dpi, facecolor="white")
plt.show()
