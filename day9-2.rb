require 'pry'

a=File.open("inputday9-1").read.split(",").map{ |x| x.to_i}
a+=[0]*1000000
  output=0
    pos=0
    rb=0
    input=2
    mode=[0,0,0]

    while (ins=a[pos].to_s)!="99"
      opcode=ins[ins.length-2..-1].to_i
      mode=[ins[-5].to_i,ins[-4].to_i,ins[-3].to_i]
      rpos=[0,0,0]
      arg0,arg1,arg2=a[pos+1..pos+3]
      rpos[0] = mode[0] == 0 ? arg2 : arg2+rb
      rpos[1] = mode[1] == 0 ? arg1 : arg1+rb
      rpos[2] = mode[2] == 0 ? arg0 : arg0+rb
      case opcode
      when 1
        a[rpos[0]]=(mode[2]==1 ? arg0 : a[rpos[2]]) + (mode[1]==1 ? arg1 : a[rpos[1]])
        pos+=4
      when 2
        a[rpos[0]]=(mode[2]==1 ? arg0 : a[rpos[2]]) * (mode[1]==1 ? arg1 : a[rpos[1]])
        pos+=4
      when 3
        a[rpos[2]]=input
        pos+=2
        input=output
      when 4
        output=mode[2]==1 ? arg0 : a[rpos[2]]
        pp output
        pos+=2
      when 5
        (mode[2]==1 ? arg0 : a[rpos[2]]) != 0 ? pos=(mode[1]==1 ? arg1 : a[rpos[1]]) : pos+=3
      when 6
        (mode[2]==1 ? arg0 : a[rpos[2]]) == 0 ? pos=(mode[1]==1 ? arg1 : a[rpos[1]]) : pos+=3
      when 7
        (mode[1]==1 ? arg1 : a[rpos[1]]) > (mode[2]==1 ? arg0 : a[rpos[2]]) ? a[rpos[0]] = 1 : a[rpos[0]] = 0
        pos+=4
      when 8
        (mode[1]==1 ? arg1 : a[rpos[1]]) == (mode[2]==1 ? arg0 : a[rpos[2]]) ? a[rpos[0]] = 1 : a[rpos[0]] = 0
        pos+=4
      when 9
        rb+=(mode[2]==1 ? arg0 : a[rpos[2]])
        pos+=2
      end
    end
