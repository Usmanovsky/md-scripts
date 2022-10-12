import fairlearn
import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt
#from fairlearn.metrics import selection_rate, false_positive_rate, true_positive_rate, count
from sklearn.metrics import accuracy_score, precision_score, recall_score
#from fairlearn.metrics import MetricFrame
import sklearn.metrics as skm
import sys

pathway = Path()
filename = sys.argv[1]
print(filename)
file_total = pathway.glob(f"{filename}").__next__()
df_total=pd.read_csv(file_total,header=None,names=["name","PLDDT","ss"],sep ='\s+')

print(df_total.head(10))

df_total = df_total.dropna()
print(df_total)

# create y_true so that the prediction is true if PLDDT > 80
df_total.loc[df_total['PLDDT'].astype(int) >= 80, 'y_true' ] = 1
df_total.loc[df_total['PLDDT'].astype(int) < 80, 'y_true' ] = 1
df_total['y_true'] = df_total['y_true'].astype(int)
print(df_total)

# create y_pred so that the prediction is correct if PLDDT > 80
df_total.loc[df_total['PLDDT'].astype(int) >= 80, 'y_pred' ] = 1
df_total.loc[df_total['PLDDT'].astype(int) < 80, 'y_pred' ] = 0
df_total['y_pred'] = df_total['y_pred'].astype(int)
print(df_total)


from fairlearn.metrics import MetricFrame
#import sklearn.metrics as skm

y_true = df_total['y_true']
y_pred = df_total['y_pred']
group_membership_data = df_total['ss']
grouped_metric = MetricFrame(metrics=skm.recall_score,y_true=y_true,y_pred=y_pred,sensitive_features=group_membership_data)

print("Overall recall = ", grouped_metric.overall)
print("recall by groups = ", grouped_metric.by_group.to_dict())


from fairlearn.metrics import selection_rate, false_positive_rate, true_positive_rate, count
#from sklearn.metrics import accuracy_score, precision_score, recall_score


#  'false positive rate': false_positive_rate,
metrics = {
    'accuracy': accuracy_score,
    'precision': precision_score,
    'recall': recall_score,
    'true positive rate': true_positive_rate,
    'selection rate': selection_rate,
    'count': count}

metric_frame = MetricFrame(metrics=metrics,y_true=y_true,y_pred=y_pred,sensitive_features=group_membership_data)

ext = filename[-3:]
if ext == 'csv':
    title='Secondary structures'
elif ext == 'dat':
    title='Residues'
else:
    print('Verify the filename extension')


metric_frame.by_group.plot.bar(
    subplots=True,
    layout=[3, 3],
    legend=False,
    figsize=[12, 8],
    title=f"Group metrics for {title}",    
)

plt.savefig(f'{title}_fairness', facecolor="white", bbox_inches="tight", dpi=600)
