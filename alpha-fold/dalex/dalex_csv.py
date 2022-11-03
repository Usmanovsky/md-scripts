import fairlearn
import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.preprocessing import OneHotEncoder
import dalex as dx 
import sys

# how-to-run: python3 dalex_dat.py path-to-dat-or-csv-file
pathway = Path()
file_name = str(sys.argv[1])
file = pathway.glob(f"{file_name}").__next__()
df=pd.read_csv(file,header=None,names=["name","PLDDT","ss"],sep ='\s+')
df = df.dropna()
df= pd.get_dummies(df,columns=["ss","name"],drop_first=False)
# create y_true so that the prediction is true if PLDDT > 80
df.loc[df['PLDDT'].astype(int) >= 80, 'y_true' ] = 1
df.loc[df['PLDDT'].astype(int) < 80, 'y_true' ] = 1
df['y_true'] = df['y_true'].astype(int)

# create y_pred so that the prediction is correct if PLDDT > 80
df.loc[df['PLDDT'].astype(int) >= 80, 'y_pred' ] = 1
df.loc[df['PLDDT'].astype(int) < 80, 'y_pred' ] = 0
df['y_pred'] = df['y_pred'].astype(int)
print(df)

#X = df.drop(['y_true','y_pred','PLDDT','ss_E'], axis=1)
# X['PLDDT'] = X['PLDDT'].astype(float)
# y = df.drop(['name','ss','PLDDT', 'y_true'], axis=1)

X = df.drop(['y_true','y_pred','PLDDT'], axis=1)
y = df[['PLDDT']]
y = y.astype('float')

# pick model
from sklearn.ensemble import GradientBoostingRegressor, RandomForestRegressor
# data splitting
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=100)
print(X_train.sum(axis=0))
print(X_test.sum(axis=0))


# training
model = DecisionTreeRegressor()
# model = GradientBoostingRegressor()
model.fit(X_train, y_train.values.ravel())
exp = dx.Explainer(model, X_test, y_test, verbose=False)
print(exp.model_performance().result)

# residue zone
#residues = ['ALA','ARG','ASN','ASP','CYS','GLU','GLN','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']
#name = 'name_'
#plot_path = 'batch-' + file.stem[-1]

#for res in residues:
#    res_attr = name + res

    # explainer model
#    protected = np.where(X_test.get(res_attr) == 1, res, "Other residues")
#    privileged = 'Other residues'

#    fobject = exp.model_fairness(protected, privileged)
#    print(fobject.fairness_check())

#    fobject.plot(show=False).write_image(f"{res}.png", format='png', engine='auto')
#    print('\n \n \n')

# secondary structure zone
#ss=['~','E','B','T','S','H','G']
#ss_name=['coil','beta-sheet','beta-bridge','turn','bend','ahelix','three-helix']
ss=['~','E','B','T','S','H','G','I']
ss_name=['coil','beta-sheet','beta-bridge','turn','bend','ahelix','three-helix','five-helix']
ss_ = 'ss_'
plot_path = 'batch-' + file.stem[-1] 

for s in ss:
    ss_attr = ss_ + s
    # explainer model
    protected = np.where(X_test.get(ss_attr) == 1, s, "Other Secondary structures")
    privileged = 'Other Secondary structures'
    
    try:
        fobject = exp.model_fairness(protected, privileged)
        print(fobject.fairness_check())
        ssname = ss_name[ss.index(s)] + file.stem[-1]
        fobject.plot(show=False).write_image(f"{plot_path}/{ssname}.png", format='png', engine='auto')
        print('\n \n \n')
    except:
        print(f"{s} has an issue")
