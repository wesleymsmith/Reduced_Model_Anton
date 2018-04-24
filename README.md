# Reduced_Model_Anton


------------ Build Notes ------------
-Initial structure: step5_protOnly.pdb
--taken from charmm-gui output for running membrane builder on crystal structure
--membrane and other solvent and ligands removed

-All 'chainTER' files are modified to add 'TER' cards after each protein chain
--perfomed using VisualStudioCode

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