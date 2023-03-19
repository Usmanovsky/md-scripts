# md-scripts
## Python and Bash scripts that help prepare, run and analyze MD simulations for deep eutectic solvents (DESs) on GROMACS

- **[DES-DES](./DES-DES)** houses scripts for simulating nultiple DESs in a box.
- **[DES-IRC](./DES-IRC)** scripts are for the automation of lots of simulations e.g. if you have 500 DESs to simulate and analyze.
- **[DES-Water](./DES-Water)** scripts are for simulating mixtures of aqueous DES systems.
- **[alpha-fold](./alpha-fold)** scripts are for the analysis of the fairness of the proteing structure predictions of AlphaFold2
- **[deepchem](./deepchem)** scripts handle a host of scenarios for training ML models using the DeepChem package.
- **des-ml** scripts can be used to train ML algorithms using the HB features of DES systems. The models can predict which 
systems will form DESs or not.
- **[interface](./interface)** scripts help analyze hydrogen bond properties of DES-Water inetrfaces.
- **[jupyter-scripts](./jupyter-scripts)** are a group of jupyter notebooks that make iterative analysis of MD data easier.
- **[lab-gpu](./lab-gpu)** scripts help with a bunch of house-cleaning operations on a local workstation.
- **[metadynamics](./metadynamics)** are for running well-tempered metadynamics simulations of plastic extraction using DESs.
- **[multi-view](./multi-view)** scripts help with protein structure prediction using sequences and contact maps.
- **[plastic-extraction](./plastic-extraction)** scripts help set up and run MD simulations for DES-Water extraction processes.
- **[template-md](./template-md)** are boiler-plate codes for running MD simulations on HPC clusters. The scripts also calculate properties
  like RDF, HB number and lifetime.
