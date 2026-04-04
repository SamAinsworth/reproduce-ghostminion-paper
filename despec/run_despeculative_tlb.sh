#!/bin/bash

# Configuration
GEM5_EXE="/home/linhenr5/reproduce-ghostminion-paper/gem5/build/ARM/gem5.opt"
SE_CONFIG="/home/linhenr5/reproduce-ghostminion-paper/gem5/configs/example/se.py"
WORKLOAD="./tlb_violator_ooo"
OUT_DIR="./m5out_tlb_strictness"

mkdir -p $OUT_DIR

echo "[*] Starting refined TLB strictness test (TLB-only flags)..."

# 1. Removed 'MMU' flag to keep trace size manageable
# 2. Kept 2> redirection because that's where your 'warn' intercepts live
${GEM5_EXE} \
    --outdir=${OUT_DIR} \
    --debug-flags=TLB \
    --debug-file=tlb_trace.out \
    ${SE_CONFIG} \
    --cpu-type=DerivO3CPU \
    --caches \
    --l2cache \
    --cmd=${WORKLOAD} \
    --param "system.cpu[0].mmu.itb.size=64" \
    --param "system.cpu[0].mmu.dtb.size=64" \
    2> "${OUT_DIR}/sim_warnings.log"

echo "[*] Simulation complete."
echo "[*] Analyzing Results..."

# Run the simplified Python scraper on the warnings log
if [ -f "parse_tlb.py" ]; then
    python3 parse_tlb.py "${OUT_DIR}/sim_warnings.log"
else
    echo "[!] parse_tlb.py not found. Running grep instead:"
    grep "skipped entry with timestamp" "${OUT_DIR}/sim_warnings.log" | head -n 20
fi

echo "[*] Done. Trace file: ${OUT_DIR}/tlb_trace.out"