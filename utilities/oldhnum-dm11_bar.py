# Interface hydrogen bond analysis DM11. This splits the box into 3 slices; 1 for bulk DES, 1 for interface, 1 for bulk water
import os, sys
from pathlib import Path
from multiprocessing import Pool
import MDAnalysis as md
from functools import partial
from MDAnalysis.analysis.hydrogenbonds.hbond_analysis import HydrogenBondAnalysis as HBA
import matplotlib.pyplot as plt
import numpy as np

print("The game has started")
# system = md.Universe("Dea-Men11_md.tpr", "Dea-Men11_md.trr")

def autolabel(rects):
    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = round(rect.get_height(),2)
        test.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom',weight='bold')
                    

def hsolve(z, limit, comp_A, comp_B, comp_C):
        lower = str(z[0])
        upper = str(z[1])
        if z < limit:
            acceptors = f"(resname {comp_A} or resname {comp_B}) and (name O02 O00 OW) and prop z > {lower} and prop z <= {upper}"
            hydrogens = f"(resname {comp_A} or resname {comp_B}) and (name H0C H0E HW1 HW2 and bonded name O*) and prop z > {lower} and prop z <= {upper}"
            #donors = box.select_atoms(f"(resname {comp_A} or resname {comp_B}) and (name H0C H0E HW1 HW2 and bonded name O*) and prop z > {lower} and prop z <= {upper}")
        elif z > limit:
            acceptors = f"(resname {comp_C}) and (name OW) and prop z > {lower} and prop z <= {upper}"
            hydrogens = f"(resname {comp_C}) and (name HW1 HW2 and bonded name O*) and prop z > {lower} and prop z <= {upper}"
            #donors = HBA.find_hydrogen_donors(hydrogens)
        else:
            acceptors = f"(resname {comp_A} or resname {comp_B} or resname {comp_C}) and (name O02 O00 OW) and prop z > {lower} and prop z <= {upper}"    
            hydrogens = f"(resname {comp_A} or resname {comp_B} or resname {comp_C}) and (name H0C H0E HW1 HW2 and bonded name O*) and prop z > {lower} and prop z <= {upper}"
            #donors = HBA.find_hydrogen_donors(hydrogens)
            
        # acceptor = "(resname Dea or resname Men or resname SOL) and (name O02 O00 OW) and prop z > " + lower + " and prop z <= " + upper
        # donor = "(resname Dea or resname Men or resname SOL) and (name H0C H0E HW1 HW2 and bonded name O*) and prop z > " + lower + " and prop z <= " + upper
        # hydrogen = "(resname Dea or resname Men or resname SOL) and (name H* and bonded name O*) and prop z > " + lower + " and prop z <= " + upper
        molecules = box.select_atoms(f"(resname {comp_B} and name O00) or (resname {comp_C} and name OW) or (resname {comp_A} and name O02) and prop z > " + lower + " and prop z <= " + upper)
        molecules_len = len(molecules)
        print(f"There are {molecules_len} molecules in {z}")        
        hb = HBA(universe=box, hydrogens_sel=hydrogens, acceptors_sel=acceptors, d_a_cutoff=3.5)
        hb.run()
        try:
                count = hb.count_by_time()
                print(len(count))
                print(count[0:])
                bin = np.average(count)/molecules_len # number of hydrogen bonds divided by the number of atoms in a slice                
                print(bin)
                print("\n")                
                return bin

        except ValueError:
                print("No hydrogen bonds in this slice")

# boundaries = ((5.0, 10.0), (10.0, 15.0), (15.0, 20.0), (20.0, 25.0), (25.0, 30.0), (30.0, 34.0), (34.0, 38.0), (38.0, 42.0), (42.0, 46.0), (46.0, 50.0), (50.0, 53.6), (53.6, 57.2), (57.2, 60.8), (60.8, 64.4), (64.4, 68.0))
boundary_set = {"Dea-Men11":((5.0,30.0),(30.0, 50.0),(50.0, 65.0)), 
"Dea-Men12":((5.0, 30.0), (30.0, 51.0), (51.0, 78.0)),
"Dea-Lid21":((5.0, 35.0), (35.0, 55.0), (55.0,80.0)),
"Men-Lid21":((5.0, 35.0), (35.0, 55.0), (55.0, 80.0)),
"Thy-Men11":((5.0, 30.0), (30.0, 45.0), (45.0, 65.0)), 
"Thy-Men21":((5.0, 35.0), (35.0, 55.0), (55.0, 75.0)), 
"Thy-Lid11":((5.0, 30.0), (30.0, 50.0), (50.0, 70.0)), 
"Thy-Lid21":((5.0, 35.0), (35.0, 55.0), (55.0, 75.0))
}
# x = []
pathway = Path()
path = str(sys.argv[1])

for file in pathway.glob(path):
    print(file.name)
    des_name = file.name
    
    if os.path.isdir(file):        
        try:
            tprfile = [ tpr.name for tpr in pathway.glob(f"{file}/*md.tpr") ]
            print(tprfile)
            des = tprfile[0].split('-')
            compound1 = des[0]
            compound2 = des[1][0:3]
            des_name = tprfile[0][:-7]
            print(compound1, compound2)
        except FileNotFoundError:
            print(f"tpr not found in {file.name}")

        try:
            trrfile = [ trr.name for trr in pathway.glob(f"{file}/*md.trr") ]
            print(trrfile)
        except FileNotFoundError:
            print(f"trr not found in {file.name}")
            
        
        box = md.Universe(f"{file}/{tprfile[0]}", f"{file}/{trrfile[0]}")
        boundaries = boundary_set[f"{des_name}"]
        water = "SOL"
        inter = "Interface"
        molA = compound1
        molB = compound2
        hlife = partial(hsolve, limit=boundaries[1], comp_A=molA, comp_B=molB, comp_C=water)

        with Pool(processes=len(boundaries)) as pool:
            hnums = pool.map(hlife, boundaries)


        try:
            with open("boundaries.txt", 'a') as h:
                for i in boundaries:
                    h.write("Boundaries: ({down} {up}) hnum={value} \n".format(down=i[0], up=i[1], value = hnums[boundaries.index(i)]))
        except TypeError:
            print("There was a problem with writing boundaries")


        x = [ np.average(i) for i in boundaries]

        try:
            with open(f"{des_name}-hnum.txt", 'a') as h:
                for i in boundaries:
                    h.write("{distance}\t{value}\n".format(distance = x[boundaries.index(i)], value = hnums[boundaries.index(i)]))
        except TypeError:
            print("There was a problem with writing hnum")


        print("Na gama")
        tags = [f"{des_name}-{des_name}", f"{des_name}-Water", "Water"]
        xrange = np.arange(len(tags))
        fig1 = plt.figure()
        fig1.set_size_inches(6, 4, forward=True)
        test = fig1.add_subplot(1,1,1)        
        test.set_ylim([0, 2.0])
        # test.set_xlim([0, 18.0])
        bar_width=0.5
        prop_cycle = plt.rcParams['axes.prop_cycle']
        colors = prop_cycle.by_key()['color']
        rects = test.bar(xrange+7, hnums, bar_width, color=colors)
        autolabel(rects)
        test.set_xlabel("Z (nm)", fontsize=14)
        test.set_ylabel(r'N $ _{HB}$',fontsize=14)
        plt.xticks(xrange+7, tags, fontsize=14, weight='bold')
        plt.yticks(fontsize=14, weight='bold')
        fig1.savefig(f'{des_name}-hnumbars.png', dpi=fig1.dpi, bbox_inches='tight')
        plt.show()
        #print(y)
        print("The game has ended")
        
