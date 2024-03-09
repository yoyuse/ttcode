# 2024-03-09

ttx: ../../data/tt-t1.ls.txt mk_ttx_svg.rb
	for x in l c r w b; do cat ../../data/tt-t1.ls.txt | awk '2 <= NF' | ruby mk_ttx_svg.rb --table tt$$x > tt$$x.svg; done
