# AlphaFold
## Python and Bash scripts that help preprocess and analyze the AlphaFold database for protein structure predictions
### Most of the scripts here depend on other scripts, so make sure you open each script to know what inputs and scripts are required for each step.
### Steps for processing AlphaFold DB for analysis:

- Download pdb from AlphaFold DB using **[pdb-downloader.sh](./re-download/pdb-downloader.sh)** or Dr Shao's scripts **[shao-scripts](./shao-scripts)**.
  * For v4 AF database, copy all the scripts in **[v4-data-download](./v4-data-download)** to a folder and follow these steps:
  * Download the v4_updated_accessions.txt from the AF website. To sample from the whole AF database, use accessions_id.csv.
  * Create batch1 csv: ```python3 **[select-samples.py](./v4-data-download/select-samples.py)** accessions_id.csv batch1.csv```
  * Create batches 2-5: ```./**[make-batches.sh](./v4-data-download/make-batches.sh)**```
  * Create download urls for each batch e.g. for batch1: ```python3 **[create-url-list.py](./v4-data-download/create-url-list.py)** batch1.csv url-batch1.csv```
  * Download pdb files using urls e.g. for batch1: ```./**[download-mcc.sh](./v4-data-download/download-mcc.sh)** url-batch1.csv```
- Convert pdb to dssp/dat files using **[dssp-pdb2dat.sh](./re-download/dssp-pdb2dat.sh)** or Dr Shao's version **[shao-scripts](./shao-scripts)**.
- Convert dssp/dat to out files using **[dat-to-out.py](./re-download/dat-to-out.py)** and **[submit-dat-to-out.sh](./re-download/submit-dat-to-out.sh)**.
- Use the scripts here **[dat-and-csv-generation](./dat-and-csv-generation)** for residue and secondary structure (ss) analysis:
  * Residues are stored in dat files e.g. ALA.dat or VAL.dat. To generate them, use **[submit-res_out_2_dat_v2.sh](./dat-and-csv-generation/submit-res_out_2_dat_v2.sh)** and **[res_out_2_dat_v2.sh](./dat-and-csv-generation/res_out_2_dat_v2.sh)** to extract residue, PLDDT and ss info from the out files in the directory:
  * SS are stored in csv files e.g. coil.csv or turn.csv. To get the secondary structure info, use **[submit-ss_out_2_csv_v2.sh](./dat-and-csv-generation/submit-ss_out_2_csv_v2.sh)** and **[ss_out_2_csv_v2.sh](./dat-and-csv-generation/ss_out_2_csv_v2.sh)** to extract residue, PLDDT and ss info from the out files in the directory.

- To segregate by number of residues in proteins, use the scripts here: **[ss-number](./ss-number)** (secondary structures) and **[res-number](./res-number)** (residues):
  * For residues, make a folder (e.g. res-number) for residues, and use **[submit_res-merger.sh](./res-number/submit_res-merger.sh)** and **[res-merger.sh](./res-number/res-merger.sh)** to classify the residues in 0-10 folders. 
  * Use **[run-datmerger.sh](./res-number/run-datmerger.sh)** and **[dat-merger.sh](./res-number/dat-merger.sh)** to merge all the dat files under each length classification.
  * For secondary structures, make a folder (e.g. ss-number) for residues, and use **[submit_ss-merger.sh](./ss-number/submit_ss-merger.sh)**  and **[ss-merger.sh](./ss-number/ss-merger.sh)** within the folder. 
  * Use **[run-csvmerger.sh](./ss-number/run-csvmerger.sh)** and **[csv-merger.sh](./ss-number/csv-merger.sh)** to merge all the csv files under each length classification.
- Generate boxplot files to be processed by our notebooks:
  * For residues, use **[run-stat-res-finder_10_90.sh](./res-number/run-stat-res-finder_10_90.sh)**, **[stat-res_10_90-finder.sh](./res-number/stat-res_10_90-finder.sh)** and **[stat-res_10_90-finder.py](./res-number/stat-res_10_90-finder.py)** in the **[res-number](./res-number)** folder that contains the 0-10 folders for residues.
  * For secondary structures, use **[run-stat-ss-finder_10_90.sh](./ss-number/run-stat-ss-finder_10_90.sh)**, **[stat-ss_10_90-finder.sh](./ss-number/stat-ss_10_90-finder.sh)** and **[stat-ss_10_90-finder.py](./ss-number/stat-ss_10_90-finder.py)**  in the **[ss-number](./ss-number)** folder that contains the 0-10 folders for secondary structures.
  * For all the dat and csv files (not segregated by length). Use **[submit-ss_total.sh](./ss-number/submit-ss_total.sh)** and **[submit-res_total.sh](./res-number/submit-res_total.sh)** to generate to generate a total_*csv and total_*dat files, and a *.boxplot file for the whole batch.
