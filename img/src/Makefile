# 2024-03-10 tt-t1.ls.txt → ttcode-4.0.ls.txt
# 2024-03-09

ttx: ../../data/ttcode-4.0.ls.txt mk_ttx_svg.rb
	for x in l c r w b; do cat ../../data/ttcode-4.0.ls.txt | awk '2 <= NF' | ruby mk_ttx_svg.rb --table tt$$x > tt$$x.svg; done
