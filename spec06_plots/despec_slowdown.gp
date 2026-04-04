set terminal pdf size 10, 4 font ",17"
set output "despec_slowdown.pdf"

# Standardize the X-axis for histograms
set xtics out nomirror rotate by 25 right
set grid y

set ylabel "Slowdown"

set bmargin 5
set rmargin 0.5

set key font ",19"
set key r above

# Configure grouped bar chart (histogram) settings
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9

# Plot a baseline at 1.0, then column 2 (DeSpec), then column 3 (GhostMinion)
plot 1 lc rgb '#444444' linetype 1 lw 2 title "", \
     'despec_slowdown.data' using 2:xtic(1) lc rgb '#20adff' title "DeSpec", \
     ''                     using 3         lc rgb '#ffd700' title "GhostMinion"