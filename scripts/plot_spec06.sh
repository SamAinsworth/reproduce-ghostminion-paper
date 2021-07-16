cd ..
BASE=$(pwd)
rm $BASE/plots/slowdown.data
for bench in xalancbmk cactusADM zeusmp astar bwaves bzip2  calculix gamess gcc GemsFDTD gobmk gromacs h264ref hmmer lbm leslie3d libquantum  milc namd omnetpp povray sjeng soplex tonto mcf
do
  echo $bench >> $BASE/plots/slowdown.data
  base=$(grep sim_se $BASE/SPEC/benchspec/CPU2006/*$bench/run/run_base_ref_aarch64.0000/m5out/statsno.txt | awk '{print $2}')
  slow=$(grep sim_se $BASE/SPEC/benchspec/CPU2006/*$bench/run/run_base_ref_aarch64.0000/m5out/statsghostminion.txt  | awk '{print $2}')
  echo $n $(echo "scale=3;$slow / $base" | bc -l) >> $BASE/plots/slowdown.data
  echo "" >> $BASE/plots/slowdown.data
done
cd $BASE/plots/
gnuplot slowdown.gp
mv slowdown.pdf spec2006.pdf
cd $BASE/scripts/
