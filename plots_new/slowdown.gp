# Output setup matching your original script
set terminal pdf size 10, 4 font ",17"
set output "slowdown.pdf"

set ylabel "Slowdown"
set yrange [0:1.2]

# Margins from your original script
set bmargin 5
set rmargin 0.5

# Grid and Tics
set grid y lc rgb "#E0E0E0" dt 3
set ytics 0.2
set xtics out nomirror rotate by 25 right

# Key/Legend setup from your original script
set key right above font ",19" horizontal

# Grouped bar chart settings
set style data histograms
set style histogram cluster gap 1.5
set style fill solid border -1
set boxwidth 1

# Plotting the data with original colors + a new blue for the 3rd bar
plot 'slowdown.data' using 2:xtic(1) title 'Base' lc rgb '#444444', \
     '' using 3 title 'Ghostminion' lc rgb '#FFD320', \
     '' using 4 title 'TLB + Ghostminion' lc rgb '#2874A6'
