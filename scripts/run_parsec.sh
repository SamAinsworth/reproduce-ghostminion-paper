cd ..
set -u
export BASE=$(pwd)
N=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
M=$(grep MemTotal /proc/meminfo | awk '{print $2}')
G=$(expr $M / 2097152)
P=$((G<N ? G : N))
i=0
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  ((i=i%P)); ((i++==0)) && wait
  (
  cd run_parsec/$bench
  $BASE/scripts/gem5_scripts/run_ghostminion_fs_checkpoint.sh $BASE/arm-gem5-rsk/parsec_rcs/$bench\_simmedium_4.rcS
  ) &
done
cd $BASE/scripts
