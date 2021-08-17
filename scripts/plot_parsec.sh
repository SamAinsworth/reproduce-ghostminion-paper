cd ..
BASE=$(pwd)
rm $BASE/plots/slowdown.data
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  echo $bench >> $BASE/plots/slowdown.data

  base=$(grep sim_se $BASE/run_parsec/$bench/m5out/statsno.txt | head -1 | awk '{print $2}')
  slow=$(grep sim_se $BASE/run_parsec/$bench/m5out/statsghostminion.txt  | head -1 | awk '{print $2}')
  echo $n $(echo "scale=3;$slow / $base" | bc -l) >> $BASE/plots/slowdown.data
  echo "" >> $BASE/plots/slowdown.data
done
cd $BASE/plots/
gnuplot slowdown.gp
mv slowdown.pdf parsec.pdf
cd $BASE/scripts/
