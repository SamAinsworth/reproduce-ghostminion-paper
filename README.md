Experimental Artefact for GhostMinion
==================================================

This repository contains artefacts and workflows 
to reproduce experiments from a paper.


Hardware pre-requisities
========================
* An x86-64 system (more cores will reduce simulation time).

Software pre-requisites
=======================

* Linux operating system (We used Ubuntu 16.04 and Ubuntu 18.04)
* A SPEC CPU2006 iso, placed in the root directory of the repository (We used v1.0).


Installation and Building
========================

You can install this repository as follows:

Extract the .tar.gz file to your working directory.

All scripts from here onwards are assumed to be run from the scripts directory, from the root of the repository:

```
cd reproduce-isca2020-muontrap-paper
cd scripts
```

To install software package dependencies, run

```
./dependencies.sh
```

Then, in the scripts folder, to compile the Guardian Council simulator and the Guardian Kernels, run
```
./build.sh
```

To compile SPEC CPU2006, first place your SPEC .iso file (other images can be used by modifying the build_spec.sh script first) in the root directory of the repository (next to the file 'PLACE_SPEC_ISO_HERE'). Then, from the scripts directory, run

```
./build_spec.sh
```

Once this has successfully completed, it will build and set up run directories for all of the benchmarks (the runs themselves will fail, as the binaries are cross compiled).




Running experimental workflows
==============================

For the SPEC CPU2006 workloads from the paper, run

```
./run_spec.sh
```

Once this is complete, within the run directories, you will find m5out/statsX files, where statsmuontrap.txt contains the time taken for the main MuonTrap scheme, statsno.txt is the unmodified system, and others are specialised setups or tuning data, as used in the original paper.

The Parsec workload is less automated. Please follow the FS mode instructions from https://github.com/arm-university/arm-gem5-rsk/blob/master/gem5_rsk.pdf to get Parsec up and running in gem5. Then, you can use

```
scripts/run_muontrap_checkpoint.sh
```

With appropriate script for each benchmark as an argument, and with your locations for the base directory, kernel and disk image defined at the top of the .sh file.

If you'd like further information on how to set this up, please contact the authors.


Authors
=======
S. Ainsworth

