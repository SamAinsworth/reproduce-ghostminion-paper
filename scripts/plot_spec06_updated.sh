cd ..
BASE=$(pwd)
rm -f $BASE/plots/slowdown.data  # Added -f to suppress errors if the file doesn't exist yet

# removed gamess and mcf - missing from SPEC2006 (v1.2) image
for bench in xalancbmk cactusADM zeusmp astar bwaves bzip2  calculix gcc GemsFDTD gobmk gromacs h264ref hmmer lbm leslie3d libquantum  milc namd omnetpp povray sjeng soplex tonto
do
  base=$(grep sim_se $BASE/SPEC/benchspec/CPU2006/*$bench/run/run_base_ref_aarch64.0000/m5out/statsno.txt | awk '{print $2}')
  slow=$(grep sim_se $BASE/SPEC/benchspec/CPU2006/*$bench/run/run_base_ref_aarch64.0000/m5out/statsghostminion.txt  | awk '{print $2}')
  
  # Print the benchmark name and the calculated ratio on the same line
  echo "$bench $(echo "scale=3;$slow / $base" | bc -l)" >> $BASE/plots/slowdown.data
done

cd $BASE/plots/
gnuplot slowdown.gp
mv slowdown.pdf spec2006.pdf
cd $BASE/scripts/