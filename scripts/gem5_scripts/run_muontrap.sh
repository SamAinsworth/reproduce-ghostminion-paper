if [ "$#" -lt 2 ]; then
    echo "Correct arguments: bench args (stdin)" && exit 1
fi
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=1000000000 --fast-forward=1000000000  --mem-size=2048MB --ghostminion --cache_coher --iminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsminion2kall.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU  --maxinsts=1000000000 --fast-forward=1000000000 --mem-size=2048MB; mv m5out/stats.txt m5out/statsno.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=1000000000 --fast-forward=1000000000  --mem-size=2048MB --ghostminion; mv m5out/stats.txt m5out/statsbaseminion2k.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=1000000000 --fast-forward=1000000000  --mem-size=2048MB --ghostminion --cache_coher; mv m5out/stats.txt m5out/statsbaseminion2kcoher.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=1000000000 --fast-forward=1000000000  --mem-size=2048MB --iminion; mv m5out/stats.txt m5out/statsbaseminion2kionly.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/se.py  -c "$1" -o "$2" -i "$3" --caches --l2cache --cpu-type=DerivO3CPU   --maxinsts=1000000000 --fast-forward=1000000000  --mem-size=2048MB --ghostminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsbaseminion2kpf.txt
#--maxinsts=1000000000 --fast-forward=1000000000
