""" 
This script retrieves properties such as hydrogen bond donor and acceptor
counts for molecules. The input list could be from a txt or excel file, 
command line input or by manually writing into compoundlist. The result 
is a dataframe which is saved as an excel file but you could change it 
to a txt or csv. Some other available properties are: 
MolecularFormula, MolecularWeight, CanonicalSMILES, IsomericSMILES
Check Pubchem for the rest.
1st argument is the excel file. 2nd arg is the sheet name.
@ulab222

"""

import pubchempy as pcp
import sys, os
import pandas as pd

if __name__ == "__main__":  # Accept command line inputs only if script is called directly.
    if len(sys.argv[1]) > 1:
        excel_file_path = os.path.abspath(str(sys.argv[1]))
    else:
        print("Something is wrong with the excel file path")

    if len(sys.argv[2]) > 1:
        sheetname = str(sys.argv[2])
    else:
        sheetname = 0  # If sheetname is empty, the first sheet will be picked


smiles_file = pd.read_excel(excel_file_path, sheet_name=sheetname)
smiles_df = pd.DataFrame(smiles_file)
# print(smiles_df)
compound_name = smiles_df.iloc[:,0].values  # Grab the compound names
properties = ['IUPACName', 'HBondAcceptorCount', 'HBondDonorCount', 'CanonicalSMILES' ]

mol = pd.DataFrame()
for compound in compound_name:
    mol_prop = pcp.get_properties(properties, compound, 'name', as_dataframe=True)
    mol_prop = mol_prop.head(1)
    mol = pd.concat([mol, mol_prop], axis=0)
    

# mol.droplevel(axis=1, level=1)
mol = mol.reset_index() 
# print(mol["HBondAcceptorCount"])
# smiles_df["IUPACName"] = mol["IUPACName"].values
# smiles_df["HBondAcceptorCount"] = mol["HBondAcceptorCount"].values
# smiles_df["HBondDonorCount"] = mol["HBondDonorCount"].values
# smiles_df["CanonicalSMILES"] = mol["CanonicalSMILES"].values
# print(smiles_df)

print(mol)
print("\n")
merged_table = pd.concat([smiles_df, mol], axis=1)
print(merged_table)
# saved_excel = os.path.basename(str(sys.argv[1]))[0:-5] + "_hb"
saved_excel = sheetname + "_hb"
merged_table.columns = ["Molecule", "Input SMILE", "Residue", "CID", "Output SMILE", "IUPAC Name", "HBD", "HBA"]
merged_table.to_excel(f"{saved_excel}.xlsx", sheet_name=sheetname)