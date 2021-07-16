cd ..
set -u
export BASE=$(pwd)
cd SPEC17/benchspec/CPU/
N=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
M=$(grep MemTotal /proc/meminfo | awk '{print $2}')
G=$(expr $M / 8192000)
P=$((G<N ? G : N))
i=0
for bench in bwaves perlbench gcc mcf omnetpp xalancbmk deepsjeng leela exchange2 xz bwaves cactusBSSN lbm wrf cam4 pop2 imagick nab fotonik3d roms
do
  ((i=i%P)); ((i++==0)) && wait
  (
  IN=$(grep $bench $BASE/spec_confs/input_2017.txt | awk -F':' '{print $2}'| xargs)
  BIN=$(grep $bench $BASE/spec_confs/binaries_2017.txt | awk -F':' '{print $2}' | xargs)
  BINA=./$(echo $BIN)"_base.mytest-64"
  echo $BINA
  ARGS=$(grep $bench $BASE/spec_confs/args_2017.txt | awk -F':' '{print $2}'| xargs)
  cd *$(echo $bench)_s/run/run_base_refspeed_mytest-64.0000
  $BASE/scripts/gem5_scripts/run_ghostminion10b.sh "$BINA" "$ARGS" "$IN" 
  ) & 
done
cd $BASE/scripts


