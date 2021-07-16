set terminal pdf size 10, 4 font ",17"
set output "slowdown.pdf"

set xtics out nomirror rotate by 25 right 1, 4, 9 format ",16"
set x2tics out scale 0 format "" -0.75, 1.5, 60

set grid x2 y

set ylabel "Slowdown"


set bmargin 5
set rmargin 0.5

set key font ",19"

set key r above

set boxwidth 1
set style fill solid border -1

plot                           1  lc rgb '#444444' linetype 1 lw 2 title "",\
     'slowdown.data' using ($0*1.5):2:xtic(1) with boxes lc rgb '#FFD320' linetype 1 title ""
