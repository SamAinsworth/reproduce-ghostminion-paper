cd ..
set -u
export BASE=$(pwd)
cd SPEC/benchspec/CPU2006/
N=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
M=$(grep MemTotal /proc/meminfo | awk '{print $2}')
G=$(expr $M / 2097152)
P=3
i=0
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  ((i=i%P)); ((i++==0)) && wait
  (
  $BASE/scripts/gem5_scripts/run_muontrap_checkpoint.sh $BASE/arm-gem5-rsk/parsec_rcs/$bench\_simmedium_4.rcS
  ) & 
done
cd $BASE/scripts
