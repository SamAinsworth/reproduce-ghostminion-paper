if [ "$#" -lt 1 ]; then
    echo "Correct arguments: script" && exit 1
fi
M5_PATH=$BASE/aarch_system

$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4  --mem-size=2048MB --script=$1 
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1; mv m5out/stats.txt m5out/statsno.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --cache_coher --iminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsminion2kall.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion; mv m5out/stats.txt m5out/statsbaseminion2k.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --cache_coher; mv m5out/stats.txt m5out/statsbaseminion2kcoher.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --iminion; mv m5out/stats.txt m5out/statsbaseminion2kionly.txt
$BASE/gem5-spectre/build/ARM/gem5.opt $BASE/gem5-spectre/configs/example/fs.py --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsbaseminion2kpf.txt
