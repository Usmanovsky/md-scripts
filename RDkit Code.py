# -*- coding: utf-8 -*-
"""
Created on Tue Dec 22 09:13:35 2020

@author: rmkal
"""


#Import Smiles Spreadsheet
Lab_Work_Smiles = pd.read_excel('ecoli smiles.xlsx')

#Defining the calculations and imporoting descriptor calculator

from rdkit.Chem import Descriptors
from rdkit.ML.Descriptors import MoleculeDescriptors


def calculate_descriptors(mols, names=None, ipc_avg=False):
    if names is None:
        names = [d[0] for d in Descriptors._descList]
    calc = MoleculeDescriptors.MolecularDescriptorCalculator(names)
    descs = [calc.CalcDescriptors(mol) for mol in mols]
    descs = pd.DataFrame(descs, columns=names)
    if 'Ipc' in names and ipc_avg:
        descs['Ipc'] = [Descriptors.Ipc(mol, avg=True) for mol in mols]      
    return descs

mols = [Chem.MolFromSmiles(s) for s in Lab_Work_Smiles['Smiles']]

#Make new variables with the calculated descriptors

Lab_Work_Monomers_RD_ecoli = calculate_descriptors(mols)

#you want to pick specific columns "NumHDonors" and "NumHAcceptors"

#Transfer columns to the new calculated descriptor dataset

Lab_Work_Monomers_RD_ecoli.index = Lab_Work_Smiles['Compound']
Lab_Work_Monomers_RD_ecoli['Bioactivity'] = Lab_Work_Smiles['Bioactivity'].values

#Save as excel files

Lab_Work_Monomers_RD_ecoli.to_excel('Lab_Work_Monomers_RD_ecoli.xlsx')

Lab_Work_Monomers_RD_ecoli = pd.read_excel('Lab_Work_Monomers_RD_ecoli.xlsx')


import pandas as pd
import warnings
warnings.filterwarnings("ignore")

from rdkit import Chem
from rdkit.Chem import AllChem, Descriptors, Draw
from rdkit.Chem.Draw import SimilarityMaps
from rdkit.Chem.Draw import IPythonConsole #Needed to show molecules
from mordred import Calculator, descriptors



