#!/usr/bin/env ruby
#
# usage: cat ttcode-4.0.ls.txt | awk '2 <= NF' | ruby mk_ttx_svg.rb --table TTX
#
# 2024-03-12 fix font-family
# 2024-03-10 tt-t1.ls.txt → ttcode-4.0.ls.txt
# 2024-03-09

# --------------------------------------------------------------------
Key = %q!1234567890qwertyuiopasdfghjkl;zxcvbnm,./!.split //
$code2ch = Hash::new

# --------------------------------------------------------------------
require 'optparse'

$OPT = ARGV.getopts("", "table:", "rowtocol")

case $OPT["table"]
when /ttl/
  $prefix = "fj"
  dark = "#26A69A"              # Teal 400
  pale = "#80CBC4"              # Teal 200
when /ttc/
  $prefix = ""
  dark = "#FFA726"              # Orange 400
  pale = "#FFCC80"              # Orange 200
when /ttr/
  $prefix = "jf"
  dark = "#EC407A"              # Pink 400
  pale = "#F48FB1"              # Pink 200
when /ttw/
  $prefix = "43"
  dark = "#424242"              # Gray 800
  pale = "#FFFFFF"
when /ttb/
  $prefix = "78"
  dark = "#424242"              # Gray 800
  pale = "#FFFFFF"
else
  raise
end
main = "#424242"                # Gray 800

# --------------------------------------------------------------------
while ln = gets
  ln.chomp!
  if /^((?:fj|jf|43|78)?..)\t(.)(\t(.*))?$/ !~ ln
    $stderr.puts "#{$0}: skipped: #{ln}"
    next
  end
  code, ch = $1, $2
  ch.tr! '0-9()!?%', '０-９（）！？％'
  $code2ch[code] = ch
end

# --------------------------------------------------------------------
unit = 16
padding = 10
margin = 10
size = unit * 40

if /ttw/ =~ $OPT["table"]
  svg = %Q!<rect x="#{margin - 2.5}" y="#{margin - 2.5}" width="#{size + padding * 2 + 5}" height="#{size + padding * 2 + 5}" fill="#FFFFFF" stroke="#{dark}" stroke-width="1"/>\n!
  svg += %Q!<rect x="#{margin + 2.5}" y="#{margin + 2.5}" width="#{size + padding * 2 - 5}" height="#{size + padding * 2 - 5}" fill="#FFFFFF" stroke="#{dark}" stroke-width="1"/>\n!
else
  svg = %Q!<rect x="#{margin}" y="#{margin}" width="#{size + padding * 2}" height="#{size + padding * 2}" fill="#FFFFFF" stroke="#{dark}" stroke-width="4"/>\n!
end

svg += %Q!<g fill="#{main}" font-family="'Hiragino Kaku Gothic ProN', 'Hiragino Sans', 'Noto Sans JP', 'Meiryo', sans-serif" font-size="#{(unit * 0.9).to_i}">\n!

Key.each_with_index do |row, j|
  y = (unit * j + padding + margin + unit * 0.9).to_i

  Key.each_with_index do |col, i|
    x = unit * i + padding + margin

    if $OPT["rowtocol"]
      fst, snd = row, col
    else
      fst, snd = col, row
    end

    code = $prefix + fst + snd
    ch = $code2ch[code]
    if ch
      ch = %Q!<text x="#{x}" y="#{y}">#{ch}</text>\n!
    else
      case code
      when "jf"   ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">▲</text>\n!
      when "fj"   ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">▽</text>\n!
      when "jfjf" ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">◆</text>\n!
      when "fjfj" ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">◇</text>\n!
      when "43"   ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">☆</text>\n!
      when "78"   ; ch = %Q!<text fill="#{dark}" x="#{x}" y="#{y}">★</text>\n!
      else        ; ch = %Q!<circle fill="#{pale}" cx="#{x + unit / 2 - 1}" cy="#{y - unit / 2 + 3}" r="2"/>\n!
      end
    end
    svg += ch
  end
end

svg += %Q!</g>\n!

# --------------------------------------------------------------------
puts <<EOF
<?xml version="1.0" standalone="no"?>

<svg width="#{unit * 40 + (padding + margin) * 2}" height="#{unit * 40 + (padding + margin) * 2}" viewBox="0 0 #{unit * 40 + (padding + margin) * 2}  #{unit * 40 + (padding + margin) * 2}" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
#{svg}</svg>
EOF

# --------------------------------------------------------------------
