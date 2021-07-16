cd ..
BASE=$(pwd)
mkdir specmnt
mkdir SPEC
sudo mount -o loop cpu2006*.iso specmnt
cd specmnt
./install.sh -d ../SPEC
cd ..
sudo umount specmnt
rm -r specmnt
cp spec_confs/aarch64.cfg SPEC/config
cd SPEC
. ./shrc   
runspec --config=aarch64.cfg --action=build astar bwaves bzip2 cactusADM calculix gamess gcc GemsFDTD gobmk gromacs h264ref hmmer lbm leslie3d libquantum mcf milc namd omnetpp povray sjeng soplex tonto xalancbmk zeusmp -I
runspec --config=aarch64.cfg --action=run --size=ref astar bwaves bzip2 cactusADM calculix gamess gcc GemsFDTD gobmk gromacs h264ref hmmer lbm leslie3d libquantum mcf milc namd omnetpp povray sjeng soplex tonto xalancbmk zeusmp --noreportable --iterations=1  -I
cd $BASE/scripts
