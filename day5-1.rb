require 'pry'

a=File.open("inputday5-1").read.split(",").map{ |x| x.to_i}

pos=0
output=0
input=1
mode=[0,0,0]

while (ins=a[pos].to_s)!="99"
  opcode=ins[ins.length-2..-1].to_i
  mode=[ins[-5].to_i,ins[-4].to_i,ins[-3].to_i]
  case opcode
  when 1
    arg0,arg1,arg2=a[pos+1..pos+3]
    a[arg2]=(mode[2]==1 ? arg0 : a[arg0]) + (mode[1]==1 ? arg1 : a[arg1])
    pos+=4
  when 2
    arg0,arg1,arg2=a[pos+1..pos+3]
    a[arg2]=(mode[2]==1 ? arg0 : a[arg0]) * (mode[1]==1 ? arg1 : a[arg1])
    pos+=4
  when 3
    arg0=a[pos+1]
    a[arg0]=input
    pos+=2
  when 4
    arg0=a[pos+1]
    output=mode[2]==1 ? arg0 : a[arg0]
    pos+=2
    pp output
  end
end


