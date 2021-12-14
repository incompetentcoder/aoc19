require 'pp'
a=File.open("inputday6-1").read.split("\n").map{|x| x.split(")").reverse}.to_h

parentsan=Array.new
parentyou=Array.new
a.keys.each do |y|
  meh=y
  while a[meh] != "COM" do
    if y=="SAN"
      parentsan.push(a[meh])
    end
    if y=="YOU"
      parentyou.push(a[meh])
    end
    meh = a[meh]
  end
end
parent = (parentsan & parentyou).first
pp parentsan.index(parent)+parentyou.index(parent)

