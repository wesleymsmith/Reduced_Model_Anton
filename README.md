# Reduced_Model_Anton


------------ Build Notes ------------
-Initial structure: step5_protOnly.pdb
--taken from charmm-gui output for running membrane builder on crystal structure
--membrane and other solvent and ligands removed

-All 'chainTER' files are modified to add 'TER' cards after each protein chain
--perfomed using VisualStudioCode

-Uniform chain naming for protein retained:
--PR1A-C,PR2A-C,PR3A-C
--capping with ACE and CT3

-Disentangling knotted chain near pore region: Prot_Full_MOEfixed.pdb
--original pdb structure from which this repository initial structure was derived
  contained regions in which only backbone coordinates were well known and had
  loops with missing segments
--homology modeling previously performed in MOE to fill in missing loops
--resulted in 'knotting' of a pair of loops near pore region
--MOE used here to fix knotting of a chain located near pore region
--coordinates of loop were moved 'by hand' in MOE to disentangle the knotted chains
--coordinates were saved as pdbv3 format
--structure checked with SILCS prep procedure

-Starting with 'Prot_Full_MOEfixed.pdb' SILCS preparation procedure was run
 on pdb of each major step to verify protein structure

 -Checked readability of Prot_Full_MOEfixed.pdb in charmm-gui: charmm-gui_Full_Fixed
 --Prot_Full_MOEfixed pdb loaded into charmm-gui pdb reader
 --resulting output verified with SILCS prep procedure
 --step1 pdb used as starting point for reduced model
 ---charmm_gui_Piezo_Full .psf and .pdb

 -Generated Reduced Model with VMD, added chain TER cards: Prot_Reduced_VMD_chainTER.pdb
 --charmm-gui_Full psf and pdb loaded into VMD
 --wrote out reduced model coordinates
 ---Selection string: "protein and resid > 1135"
 --TER cards added to chains

 -Checked Readibility of Prot_Reduced_VMD_chainTER.pdb with charmm-gui: charmm-gui_Piezo_Reduced
 --Prot_Reduced_VMD_chainTER.pdb loaded into charmm-gui pdb reader
 --structure checked with SILCS prep procedure
 --TER cards added to end of chains for step1
 --step1 pdb with TER cards used as starting point for membrane and yoda+membrane models
 ---charmm_gui_Piezo_Reduced_chainTER.pdb

 -Building Piezo + Membrane system in charmm-gui:
 --charmm_gui_Piezo_Reduced_chainTER.pdb loaded into charmm-gui membrane builder
 --membrane added centered on hydrophobic arms com
 ---required roughly -100 angstrom shift during build process
 ----See: Piezo_Reduced_Membrane_centering.png
 --membrane build info:
 ---POPC 1:1 (upper:lower)
 ---length of XY based on 'Ratios of lipid components'
 ---length of X and Y (initial guess): 190
 ---length of Z based on 'Water thickness 10'
 --- --- charmm-gui membrane builder system info results ---
 --- Calculated Number of Lipids:
 --- Lipid Type	Upperleaflet 
 --- Number	Lowerleaflet 
 --- Number
 --- POPC	439	386
 --- Calculated XY System Size:
 ---  	Upperleaflet	Lowerleaflet
 --- Protein Area	6136.83625	9798.1609
 --- Lipid Area	29983.7	26363.8
 --- # of Lipids	439	386
 --- Total Area	36120.53625	36161.9609
 --- Protein X Extent	93.95	
 --- Protein Y Extent	91.65	 
 --- Average Area	36141.25	
 --- A	190.11	
 --- B	190.11	 
 --- --- --- --- --- --- --- --- --- --- ---

 - Building Piezo + Yoda in membrane: Peizo_Yoda_Build -
 -Addition of 20 Yoda ligands to Piezo Model: Piezo_Reduced_Yoda_VMD_chainTER.pdb
 -loaded charmm_gui_Piezo_Reduced.psf and charmm_gui_Piezo_Reduced_chainTER.pdb into VMD
 -added 20 YODA ligands to system using 
 --additions performed using 'vmd_drawing_scripts.tcl'
 --added 6 YODA ligands betweeen each pair of monomer arms
 ---Ligand pdb: yoda.geomOpt.pdb
 ----MP2 QM optimization of yoda in vaccuo, performed using Gaussian
 ---trimer structure -> 3 arms -> 3 monomer arm pairs
 ---tcl/tk console history log file: 

 