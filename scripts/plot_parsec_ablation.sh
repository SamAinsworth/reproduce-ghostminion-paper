#!/usr/bin/env bash
# Build ablation.data from home dirs, then gnuplot (same spirit as plot_parsec.sh: sim_seconds ratio vs baseline).
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1
BASE=$(pwd)
WITHOUT="${PARSEC_WITHOUT:-$HOME/parsec_without_changes}"
WITH_TLB="${PARSEC_WITH_TLB:-$HOME/parsec_with_tlb_only}"

OUT="$BASE/plots/ablation.data"
mkdir -p "$BASE/plots"
rm -f "$OUT"

get_se() {
  grep '^sim_seconds' "$1" | head -1 | awk '{print $2}'
}

{
  echo "# benchmark  base(1)  ghostminion/base  tlb_gm/base"
  for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions; do
    f_base="$WITHOUT/${bench}_statsno.txt"
    f_gm="$WITHOUT/${bench}_statsghostminion_old.txt"
    f_tlb="$WITH_TLB/${bench}_statsghostminion.txt"
    if [[ ! -f "$f_base" || ! -f "$f_gm" || ! -f "$f_tlb" ]]; then
      echo "[plot_parsec_ablation] skip $bench (need all three: statsno, statsghostminion_old, with_tlb statsghostminion)" >&2
      continue
    fi
    b0=$(get_se "$f_base")
    g0=$(get_se "$f_gm")
    t0=$(get_se "$f_tlb")
    if [[ -z "$b0" || "$b0" == "0" ]]; then
      echo "[plot_parsec_ablation] skip $bench: bad baseline sim_seconds" >&2
      continue
    fi
    rgm=$(echo "scale=6; $g0 / $b0" | bc -l)
    rtl=$(echo "scale=6; $t0 / $b0" | bc -l)
    printf '%s 1.0 %s %s\n' "$bench" "$rgm" "$rtl"
  done
} >"$OUT"

if ! grep -v '^#' "$OUT" | grep -q .; then
  echo "[plot_parsec_ablation] no complete benchmark rows in $OUT — nothing to plot." >&2
  exit 1
fi

cd "$BASE/plots"
if ! gnuplot ablation.gp 2> "$BASE/plots/.ablation_gnuplot.err"; then
  echo "[plot_parsec_ablation] gnuplot failed:" >&2
  cat "$BASE/plots/.ablation_gnuplot.err" >&2
  rm -f "$BASE/plots/.ablation_gnuplot.err"
  exit 1
fi
rm -f "$BASE/plots/.ablation_gnuplot.err"
PDF="$BASE/plots/ablation.pdf"
PNG="$BASE/plots/ablation.png"
if [[ ! -s "$PDF" ]]; then
  echo "[plot_parsec_ablation] error: $PDF missing or empty (run from repo: bash scripts/plot_parsec_ablation.sh; gnuplot by hand needs: cd plots && gnuplot ablation.gp)." >&2
  exit 1
fi
if [[ ! -s "$PNG" ]]; then
  echo "[plot_parsec_ablation] warning: $PNG missing — pngcairo may be unavailable; PDF should still be valid." >&2
else
  cp -f "$PNG" "$BASE/plots/parsec_ablation.png"
fi
cp -f "$PDF" "$BASE/plots/parsec_ablation.pdf"
echo "[plot_parsec_ablation] wrote:"
echo "  $PDF"
echo "  $PNG   (open this if the PDF preview is blank in the editor)"
echo "  $BASE/plots/parsec_ablation.pdf  (copy)"
[[ -s "$PNG" ]] && echo "  $BASE/plots/parsec_ablation.png  (copy)"
echo "[plot_parsec_ablation] data: $OUT"
echo "Note: parsec.pdf is from plot_parsec.sh (Ghostminion vs base only). Ablation is ablation.pdf / ablation.png."
