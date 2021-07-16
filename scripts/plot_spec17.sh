cd ..
BASE=$(pwd)
rm $BASE/plots/slowdown.data
for bench in bwaves perlbench gcc mcf omnetpp xalancbmk deepsjeng leela exchange2 xz bwaves cactusBSSN lbm wrf cam4 pop2 imagick nab fotonik3d roms
do
  echo $bench >> $BASE/plots/slowdown.data

  base=$(grep sim_se $BASE/SPEC17/benchspec/CPU/*$(echo $bench)_s/run/run_base_refspeed_mytest-64.0000/m5out/statsno.txt | awk '{print $2}')
  slow=$(grep sim_se $BASE/SPEC17/benchspec/CPU/*$(echo $bench)_s/run/run_base_refspeed_mytest-64.0000/m5out/statsghostminion.txt  | awk '{print $2}')
  echo $n $(echo "scale=3;$slow / $base" | bc -l) >> $BASE/plots/slowdown.data
  echo "" >> $BASE/plots/slowdown.data
done
cd $BASE/plots/
gnuplot slowdown.gp
mv slowdown.pdf spec2017.pdf
cd $BASE/scripts/
