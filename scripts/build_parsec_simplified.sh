cd ..
BASE=$(pwd)
cd aarch_system
cd disks
tar -xvf aarch64-ubuntu-trusty-headless.img.tar.gz
cd ..
cd binaries
tar -xvf vmlinux.arm64.tar.gz
cd $BASE
cd gem5/system/arm/dt
make
cd $BASE
mkdir run_parsec
cd run_parsec
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  mkdir $bench
done

