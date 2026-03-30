if [ "$#" -lt 1 ]; then
    echo "Correct arguments: script" && exit 1
fi
M5_PATH=$BASE/aarch_system

# Extract benchmark name from the input script path
BENCH=$(basename $1 _simmedium_4.rcS)

# Only create checkpoint if it doesn't already exist
if ! ls -d $BASE/run_parsec/$BENCH/m5out/cpt.* > /dev/null 2>&1; then
  $BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4  --mem-size=2048MB --script=$1 #Make checkpoints
fi

# Only generate statsno.txt if it's missing or empty
if [ ! -s $BASE/run_parsec/$BENCH/m5out/statsno.txt ]; then
  $BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1; mv m5out/stats.txt m5out/statsno.txt
fi

# Only generate statsghostminion.txt if it's missing or empty
if [ ! -s $BASE/run_parsec/$BENCH/m5out/statsghostminion.txt ]; then
  $BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --cache_coher --iminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsghostminion.txt
fi
#$BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion; mv m5out/stats.txt m5out/statsbaseminion2k.txt
#$BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --cache_coher; mv m5out/stats.txt m5out/statsbaseminion2kcoher.txt
#$BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --iminion; mv m5out/stats.txt m5out/statsbaseminion2kionly.txt
#$BASE/gem5/build/ARM/gem5.opt $BASE/gem5/configs/example/fs.py  --bootloader=$BASE/aarch_system/binaries/boot.arm64 --machine-type=VExpress_GEM5_V1 --kernel=$BASE/aarch_system/binaries/vmlinux.arm64 --dtb-file=$BASE/gem5/system/arm/dt/armv8_gem5_v1_4cpu.dtb --disk-image=$BASE/aarch_system/disks/aarch64-ubuntu-trusty-headless.img -n 4 --mem-size=2048MB --caches --l2cache --cpu-type=DerivO3CPU  --checkpoint-dir=m5out -r 1 --ghostminion --prefetch_ordered ; mv m5out/stats.txt m5out/statsbaseminion2kpf.txt

