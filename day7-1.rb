require 'pry'

b=File.open("inputday7-1").read.split(",").map{ |x| x.to_i}

outputs=Hash.new
phases=[0,1,2,3,4].permutation.to_a.each do |x|
  output=0
  outputs[x]=[]
  x.each do |y|
    a=b.clone
    pos=0
    input=y
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
        input=output
      when 4
        arg0=a[pos+1]
        output=mode[2]==1 ? arg0 : a[arg0]
        pos+=2
      when 5
        arg0,arg1=a[pos+1..pos+2]
        (mode[2]==1 ? arg0 : a[arg0]) != 0 ? pos=(mode[1]==1 ? arg1 : a[arg1]) : pos+=3
      when 6
        arg0,arg1=a[pos+1..pos+2]
        (mode[2]==1 ? arg0 : a[arg0]) == 0 ? pos=(mode[1]==1 ? arg1 : a[arg1]) : pos+=3
      when 7
        arg0,arg1,arg2=a[pos+1..pos+3]
        (mode[1]==1 ? arg1 : a[arg1]) > (mode[2]==1 ? arg0 : a[arg0]) ? a[arg2] = 1 : a[arg2] = 0
        pos+=4
      when 8
        arg0,arg1,arg2=a[pos+1..pos+3]
        (mode[1]==1 ? arg1 : a[arg1]) == (mode[2]==1 ? arg0 : a[arg0]) ? a[arg2] = 1 : a[arg2] = 0
        pos+=4
      end
    end
  end
  outputs[x].push(output)
end
pp outputs.sort_by {|x| x[1]}.last
