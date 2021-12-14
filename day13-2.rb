require 'pry'

a=File.open("inputday13-1").read.split(",").map{ |x| x.to_i}
a[0]=2
a+=[0]*10000
panels=[0]*10000
length=100
  output=0
  outputs=[]
    pos=0
    rb=0
    input=1
    mode=[0,0,0]
    score=0
    ballpos=0
    paddlepos=0

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
        if ballpos == paddlepos
          input=0
        elsif ballpos < paddlepos
          input=-1
        elsif ballpos > paddlepos
          input=1
        end
        a[rpos[2]]=input
        pos+=2
      when 4
        output=mode[2]==1 ? arg0 : a[rpos[2]]
        outputs.push(output)
        if outputs.length == 3
          if outputs[0] == -1 && outputs[1] == 0
            score=outputs[2]
          else
            panels[outputs[1]*length+outputs[0]] = outputs[2]
            if outputs[2] == 3
              paddlepos = outputs[0]
            elsif outputs[2] == 4
              ballpos = outputs[0]
            end
          end
          outputs=[]
        end
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
pp score
