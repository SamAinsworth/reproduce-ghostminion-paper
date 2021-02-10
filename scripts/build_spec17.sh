cd ..
BASE=$(pwd)
mkdir specmnt
mkdir SPEC17
sudo mount -o loop cpu2017*.iso specmnt
cd specmnt
./install.sh -d ../SPEC17
cd ..
sudo umount specmnt
rm -r specmnt
cp spec_confs/aarch64_17.cfg SPEC17/config
cd SPEC
. ./shrc   
runcpu --config=aarch64_17.cfg --action=build perlbench gcc mcf omnetpp xalancbmk x264 deepsjeng leela exchange2 xz bwaves cactusBSSN lbm wrf cam4 pop2 imagick nab fotonik3d roms -I
runcpu --config=aarch64_17.cfg --action=run --size=ref perlbench gcc mcf omnetpp xalancbmk x264 deepsjeng leela exchange2 xz bwaves cactusBSSN lbm wrf cam4 pop2 imagick nab fotonik3d roms --noreportable --iterations=1  -I
cd $BASE/scripts
