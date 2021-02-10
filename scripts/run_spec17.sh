cd ..
set -u
export BASE=$(pwd)
cd SPEC/benchspec/CPU2006/
N=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
M=$(grep MemTotal /proc/meminfo | awk '{print $2}')
G=$(expr $M / 4097152)
P=16
i=0
for bench in perlbench gcc mcf omnetpp xalancbmk x264 deepsjeng leela exchange2 xz bwaves cactusBSSN lbm wrf cam4 pop2 imagick nab fotonik3d roms
do
  ((i=i%P)); ((i++==0)) && wait
  (
  IN=$(grep $bench $BASE/spec_confs/input.txt | awk -F':' '{print $2}'| xargs)
  BIN=$(grep $bench $BASE/spec_confs/binaries.txt | awk -F':' '{print $2}' | xargs)
  BINA=./$(echo $BIN)"_base.aarch64"
  echo $BINA
  ARGS=$(grep $bench $BASE/spec_confs/args.txt | awk -F':' '{print $2}'| xargs)
  cd *$(echo $bench)_s/run/run_base_ref_aarch64.0000
  $BASE/scripts/gem5_scripts/run_muontrap.sh "$BINA" "$ARGS" "$IN" 
  ) & 
done
cd $BASE/scripts


