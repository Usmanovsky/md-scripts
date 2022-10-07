import pubchempy as pcp
import csv

# edit to change path of CSV file
PATH='D:\\Documents\\DES Sim\\Compounds_Ex.csv'

# Preparing new csv file
filename="SMILE List"
ff=open(filename, "w")

# Making initial header in new csv
headers = "Compound, Canonical SMILE \n"
ff.write(headers)

# Initializing array for holding SMILE streams and Names
SMILEs = []
Names = []

# Opens CSV file
with open(PATH) as f:
    reader = csv.reader(f)

    for row in reader:
        # For every compound, the Compound ID from PubChem is acquired using the name of the compound within the CSV
        # file
        CID = pcp.get_compounds(row, 'name')

        # This section of code cleans up the Compound ID. The Compound ID is normally retrieved in the form
        # "[Compound(num)]" this cleans it up to generate an integer of num that can be fed into the compound function
        # There may be better ways to do this, but this is how I got it to work. Inputting "Compound(num)" into
        # pcp.Compound.from_cid(x) for x led to errors. The only way I was able to make this work is by using x as an
        # integer.
        c = (", ".join( repr(e) for e in CID))
        c=c.strip('Compound()')
        c=int(c)

        # This uses the Compound ID and converts it into a usable form so we can retrieve other information about the
        # molecule
        z=pcp.Compound.from_cid(c)

        # Uses the prepared variable above to search for the SMILE stream. Name is redundant, but may be useful when
        # CSV file is needed
        SMILE=z.canonical_smiles
        Name=z.iupac_name

        # Adding current SMILE to the total SMILEs array
        SMILEs.append(SMILE)
        Names.append(Name)
        print(SMILEs)
        print(Names)

# Writing the names and SMILEs of the compound to new CSV
for i in range(len(SMILEs)):
    ff.write(Names[i] + "," + SMILEs[i] + "\n")

ff.close()
