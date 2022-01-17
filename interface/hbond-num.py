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
hnumber = []
unique_atoms = {
"Dea":"O02",
"Men":"O00",
"Lid":"O07",
"Thy":"O04",
"SOL":"OW"
}

def autolabel(rects):
    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = round(rect.get_height(),2)
        test.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom',weight='bold',fontsize='14')
                    
def hnum(acceptors,hydrogens, comp_A, comp_B, comp_C, z, limit, mols,water=False):
    atomsA = unique_atoms[f"{comp_A}"]
    atomsB = unique_atoms[f"{comp_B}"]
    atomsC = unique_atoms[f"{comp_C}"]
    lower = str(z[0])
    upper = str(z[1])
    molecules = mols
           
    hb = HBA(universe=box, d_h_a_angle_cutoff=140, hydrogens_sel=hydrogens, acceptors_sel=acceptors, d_a_cutoff=3.5, update_selections=True)
    hb.run()
    n_frames = hb.frames.size
    #for donor, acceptor, count in hb.count_by_type():
        #donor_resname, donor_type = donor.split(":")
        #try:
           # n_donors = box.select_atoms(f"resname {donor_resname} and type {donor_type}").n_atoms
        #except ZeroDivisionError:
            #print('Zero donors')

        # average number of hbonds per donor molecule per frame
        #mean_count = int(count) / (n_frames)
        #print(f"{donor} to {acceptor}: {mean_count:.2f} \n")

    try:
        if water == False:
            count = hb.count_by_time()/molecules
            print('Water mode: ', water) 
        elif water == True:    
            count = (hb.count_by_time()*2)/molecules    
            print('WATER mode: ', water) 
        else:
            print("Could not detect water mode")
        #count = hb.count_by_time()/molecules
        print(len(count))
        print(count)
        bin = (np.average(count)) # number of hydrogen bonds divided by the number of mols in a slice                
        print("Average hbonds per molecule: ",bin)
        print("\n")                
        return bin

    except ValueError:
        print("No hydrogen bonds in this slice")

def hsolve(z, limit, comp_A, comp_B, comp_C):
        atomsA = unique_atoms[f"{comp_A}"]
        atomsB = unique_atoms[f"{comp_B}"]
        atomsC = unique_atoms[f"{comp_C}"]
        lower = str(z[0])
        upper = str(z[1])
        if z < limit:  # Bulk DES
            acceptors = f"(resname {comp_A} or resname {comp_B}) and (name O* N*) and prop z >= {lower} and prop z <= {upper}"
            hydrogens = f"(resname {comp_A} or resname {comp_B}) and (name H* and bonded name O* N*) and prop z >= {lower} and prop z <= {upper}"
            molecules_DES = box.select_atoms(f"(resname {comp_B} and name {atomsB}) or (resname {comp_A} and name {atomsA}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            print(f"There are {molecules_DES} {comp_A} plus {comp_B} molecules in Bulk DES zone {lower}-{upper}")
            # print("Bulk DES zone")
            num = hnum(acceptors, hydrogens, comp_A,comp_B, comp_C, z, limit, molecules_DES)
            return num
            
        elif z > limit:  # Bulk water
            #acceptors=None
            #hydrogens=None
            acceptors_W = f"(resname {comp_C} and name OW*) and prop z >= {lower} and prop z <= {upper}"
            hydrogens_W = f"(resname {comp_C}  and name HW*) and prop z >= {lower} and prop z <= {upper}"
            molecules_WATER = box.select_atoms(f"(resname {comp_C} and name {atomsC}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            print(f"There are {molecules_WATER} {comp_C} molecules in Bulk water zone {lower}-{upper}")
            # print("Bulk water zone")
            num = hnum(acceptors_W, hydrogens_W, comp_A,comp_B, comp_C, z, limit, molecules_WATER, water=True)
            return num
        else:
            acceptors_des = f"(resname {comp_A} or resname {comp_B}) and (name O*) and prop z >= {lower} and prop z <= {upper}"    
            hydrogens_des = f"(resname {comp_A} or resname {comp_B}) and (name H* and bonded name O* N*) and prop z >= {lower} and prop z <= {upper}"
            molecules_des = box.select_atoms(f"(resname {comp_B} and name {atomsB}) or (resname {comp_A} and name {atomsA}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            print(f"There are {molecules_des} {comp_A} plus {comp_B} molecules in Interface DES-DES zone {lower}-{upper}")
            # print("Interface DES-DES zone")
            num1 = hnum(acceptors_des, hydrogens_des, comp_A,comp_B, comp_C, z, limit, molecules_des)
                        
            acceptors_int = f"(resname {comp_A} or resname {comp_B} or resname {comp_C}) and (name O* N*) and prop z >= {lower} and prop z <= {upper}"    
            hydrogens_int = f"(resname {comp_A} or resname {comp_B} or resname {comp_C}) and (name H* and bonded name O* N*) and prop z >= {lower} and prop z <= {upper}"
            molecules_int = box.select_atoms(f"(resname {comp_B} and name {atomsB}) or (resname {comp_A} and name {atomsA}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            water_int = box.select_atoms(f"(resname {comp_C} and name {atomsC}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            print(f"There are {molecules_int} {comp_A} plus {comp_B} plus {water_int} {comp_C}  molecules in Interface DES-Water zone {lower}-{upper}")
            # print("Interface DES-Water zone")
            num2 = hnum(acceptors_int, hydrogens_int, comp_A,comp_B, comp_C, z, limit, molecules_int)
            
            acceptors_water = f"(resname {comp_C} and name OW*) and prop z >= {lower} and prop z <= {upper}"    
            hydrogens_water = f"(resname {comp_C} and name HW*) and prop z >= {lower} and prop z <= {upper}"
            molecules_water = box.select_atoms(f"(resname {comp_C} and name {atomsC}) and prop z >= {lower} and prop z <= {upper}").n_atoms
            print(f"There are {molecules_water} {comp_C} molecules in Interface water-water zone {lower}-{upper}")
            #print("Interface Water-Water zone")
            num3 = hnum(acceptors_water, hydrogens_water, comp_A,comp_B, comp_C, z, limit, molecules_water, water=True)
            #return num1, num2, num3
            hnumber.append(num1)
            hnumber.append(num2)
            hnumber.append(num3)
            return hnumber

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

        with Pool(processes=5) as pool:
            hnums = pool.map(hlife, boundaries)

        hnums1 = []
        hnums1.append(hnums[0])
        hnums1.append(hnums[1][0])
        hnums1.append(hnums[1][1])
        hnums1.append(hnums[1][2])
        hnums1.append(hnums[2])
        print("hnums: ",hnums1)


        
        print("Na gama")
        w="Water"
        d="DES"
        tags = [f"{d}\n (Bulk)", f"{d}\n (Interface)", f"{d}-{w}\n (Interface)", f"{w}\n (Interface)", f"{w}\n (Bulk)"]
        xrange = np.arange(len(tags))
        fig1 = plt.figure()
        fig1.set_size_inches(8, 8, forward=True)
        test = fig1.add_subplot(1,1,1)        
        test.set_ylim([0, 32.0])
        # test.set_xlim([0, 8.0])
        bar_width=0.35
        prop_cycle = plt.rcParams['axes.prop_cycle']
        colors = prop_cycle.by_key()['color']
        rects = test.bar(xrange+2, hnums1, bar_width, color=colors)
        autolabel(rects)
        test.set_xlabel("Z (nm)", fontsize=14, weight='bold')
        test.set_ylabel(r'N $ _{HB}$',fontsize=14)
        plt.xticks(xrange+2, tags, fontsize=14, weight='bold')
        plt.yticks(fontsize=14, weight='bold')
        fig1.savefig(f'{file}/{des_name}-hnumbars.png', dpi=fig1.dpi, bbox_inches='tight')
        plt.show()
        print("The game has ended")
        
