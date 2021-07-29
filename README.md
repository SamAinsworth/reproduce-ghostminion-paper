Artefact Evaluation for GhostMinion
==================================================

This repository contains artefacts and workflows 
to reproduce experiments from the MICRO 2021 paper
by S. Ainsworth 

"GhostMinion: A Strictness-Ordered Cache System for Spectre Mitigation"

Including a modified gem5 simulator based on 

commit 090fa08c149768e940f857df9cb936da23ae48da
Author: Bobby R. Bruce <bbruce@ucdavis.edu>
Date:   Wed Sep 30 11:14:02 2020 -0700

and scripts for compiling and running SPEC CPU2006, SPECspeed 2017, and Parsec.

Hardware pre-requisities
========================
* An x86-64 system (more cores will reduce simulation time, so ideally a server) preferably with sudo access (to install dependencies).

Software pre-requisites
=======================

* Linux operating system (We used Ubuntu 16.04 and Ubuntu 18.04)
* A SPEC CPU2006 iso, placed in the root directory of the repository (We used v1.0).
* AND/OR A SPEC CPU2017 iso, placed in the root directory of the repository.

Installation and Building
========================

You can install this repository as follows:

```
git clone https://github.com/SamAinsworth/reproduce-ghostminion-paper
```

All scripts from here onwards are assumed to be run from the scripts directory, from the root of the repository:

```
cd reproduce-ghostminion-paper
cd scripts
```

To install software package dependencies, run

```
./dependencies.sh
```

Then, in the scripts folder, to compile the GhostMinion simulator, run
```
./build.sh
```

To compile SPEC CPU2006, first place your SPEC .iso file (other images can be used by modifying the build_spec06.sh script first) in the root directory of the repository (next to the file 'PLACE_SPEC_ISO_HERE'). 

Name it "cpu2006.iso" or change the script as appropriate.

Then, from the scripts directory, run

```
./build_spec06.sh
```

Once this has successfully completed, it will build and set up run directories for all of the benchmarks (the runs themselves will fail, as the binaries are cross compiled).

To do the same with SPECspeed 2017, place a SPECspeec 2017 iso (name starting with cpu2017 and ending in iso, i.e. "cpu2017-1_0_2.iso", or with appropriate modification to the script), and run

```
./build_spec17.sh
```

If you wish to run the Parsec workloads in FS mode, 

```
./build_parsec.sh
```

Will download Parsec itself, along with the Arm gem5 research kit and an Ubuntu distribution. This has more dependencies so is expected to be more brittle than the SPEC workflows.


Running experimental workflows
==============================

For the SPEC CPU2006 workloads from the paper, run

```
./run_spec06.sh
```



Similarly, for SPEC 2017:

```
./run_spec17.sh
```

And Parsec

```
./run_parsec.sh
```


If any unexpected behaviour is observed, please report it to the author.

Shorter/Longer workflow
==============================


If you have a system with fewer cores, and/or to test the setup, simulation time can be reduced by removing workloads from the three experiments. The simplest to run will be SPEC CPU2006, and so you could pick some of the more interesting points from Figure 6, and only run those experiments. To do this, remove the other workloads from line 10 of run_spec06.sh, eg.

```
for bench in xalancbmk cactusADM zeusmp astar bwaves bzip2  calculix gamess gcc GemsFDTD gobmk gromacs h264ref hmmer lbm leslie3d libquantum  milc namd omnetpp povray sjeng soplex tonto mcf
```

becomes


```
for bench in xalancbmk cactusADM zeusmp astar
```

On the flip side, if you wanted to reproduce more experiments from the paper, or customise and run new experiments, examples on how to configure the simulator are given in commented-out commands in e.g. scripts/gem5_scripts/run_ghostminion.sh

These options are also documented in gem5/configs/common/Options.py.

Customisation of Options (for fans of gem5)
==============================

The gem5 options we use in GhostMinion are as follows:

```
parser.add_option("--ghostminion", action="store_true",default=False)
```
Enables GhostMinion itself, by placing a GhostMinion at the side of each L1 data cache.

```
parser.add_option("--iminion", action="store_true",default=False)
```
Same as --ghostminion, but for instruction rather than data caches.
    

```
parser.add_option("--cache_coher", action="store_true",default=False)
```
Enables cache coherence protection (needs --ghostminion).


```
 parser.add_option("--prefetch_ordered", action="store_true",default=False)
```
Enables prefetching only based on committed state (needs --ghostminion).


```
parser.add_option("--ghost_size", type="string", default="2kB")
```
Changes the size of each GhostMinion (default 2kB).


```
parser.add_option("--ghost_assoc", type="int", default="2")
``` 
Changes the associativity of each GhostMinion (default 2).

```
parser.add_option("--block_contention", action="store_true",default=False)
```

Adds protection against backwards-in-time attacks that use in-core units, such as the FPU, by scheduling operations that use non-pipelined units in order with respect to other operations that use the same unit. This speeds up both GhostMinion and the baseline system, so we switch it off by default to avoid masking other overheads.


Validation of results
==============================

To generate graphs of the data, from the scripts folder run

```
./plot_spec06.sh
```

or 


```
./plot_spec17.sh
```

or


```
./plot_parsec.sh
```

This will extract the data from the simulation runs' m5out/stats.txt files, and plot it using gnuplot. The plots themselves will be in the folder plots, and the data covered should look broadly similar to the slowdown figures for GhostMinion presented in figures 6,7 and 8 in the paper. 

The raw data will be accessible in the run directories within the spec or parsec folders, as stats*.txt (look in the scripts to find precisely where).


If anything is unclear, or any unexpected results occur, please report it to the author.

Author
=======
Sam Ainsworth

