# gnuplot relationships_4_cluster.plt
# display relationships_4_cluster.png

#set terminal png
set term png font '/usr/share/fonts/msttcore/times.ttf,14'
set output "relationships_4_cluster.png"  

set xrange [1:8]
set yrange [-2:80]
set ytics 0,4,80

set ytics nomirror
set y2range [-24:140]
#set y2tics 5
set y2tics 0,8,140

set grid

# set key box reverse top Left Right samplen 2 spacing 1.2
set key at 4,78 top Right samplen 2

set xlabel "Number of Keywords"
set ylabel "ART for Cluster-40 / Cluster-60 (seconds)"
set y2label "ART for Cluster-100 (seconds)"

#plot 'relationships_4_user_sys.dat' using 1:2 title "The Average RTT of ping" with lines ls 1 lw 1 lc "red"

#plot 'relationships_4_user_sys.dat' using 1:2 axis x1y1 title "Average RTT" with linespoints pointtype 2, \
#     'relationships_4_io.dat' using 1:2 axis x1y2 title "CPU Utilization" with linespoints pointtype 3

plot 'relationships_4_cluster.dat' using 1:2 axis x1y1 title "clu-40-user-sys" with lp pt 1 lw 1 lc "red", \
     'relationships_4_cluster.dat' using 1:3 axis x1y1 title "clu-40-io" with lp pt 2 lw 1 lc "green", \
     'relationships_4_cluster.dat' using 1:4 axis x1y1 title "clu-60-user-sys" with lp pt 3 lw 1 lc "blue", \
     'relationships_4_cluster.dat' using 1:5 axis x1y1 title "clu-60-io" with lp pt 4 lw 1 lc "orange", \
     'relationships_4_cluster.dat' using 1:6 axis x1y2 title "clu-100-user-sys" with lp pt 5 lw 1 lc "purple", \
     'relationships_4_cluster.dat' using 1:7 axis x1y2 title "clu-100-io" with lp pt 6 lw 1 lc "olive"
