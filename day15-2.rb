require 'pry'

a=File.open("inputday15-1").read.split(",").map{ |x| x.to_i}
a+=[0]*10000
panels=["-"]*10000
length=100
  output=0
  outputs=[]
    pos=0
    rb=0
    input=1
    mode=[0,0,0]
    robopos=[50,50]
    panels[robopos[1]*length+robopos[0]]="X"
    direction={1 => [0,-1], 2 => [0,1], 3 => [-1,0], 4 => [1,0]}
    directions=[1,4,2,3]
    found=0
    oxygen=0

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
      when 4
        output=mode[2]==1 ? arg0 : a[rpos[2]]
        outputs.push(output)
        case output
        when 0
          tmp=[robopos[0]+direction[input][0],robopos[1]+direction[input][1]]
          panels[tmp[1]*length+tmp[0]] = "W"
        when 1
          robopos.each_index {|x| robopos[x]+=direction[input][x]}
          panels[robopos[1]*length+robopos[0]] = 0
        when 2
          robopos.each_index {|x| robopos[x]+=direction[input][x]}
          panels[robopos[1]*length+robopos[0]] = 2
          oxygen=robopos.clone
        end
        surrounds=[]
        directions.each do |x|
          surrounds.push(panels[(robopos[1]+direction[x][1])*length+robopos[0]+direction[x][0]])
        end
        if dir=surrounds.find_index("-")
          input=directions[dir]
        else
          if surrounds.count("W") + surrounds.count("D") == 3
            panels[robopos[1]*length+robopos[0]] = "D"
          end
          if surrounds.count("W") + surrounds.count("D") == 4
            found=1
            break
          end
          input=directions[surrounds.find_index(0)] if surrounds.find_index(0)
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
      break if found==1
    end
    panels.each_slice(100) {|x| pp x.join}
    
    panels.each_index {|x| panels[x]=0 if panels[x]=="D"}
    panels[oxygen[1]*length+oxygen[0]]=2
    count=0
    while panels.count(0) > 0 do
      count+=1
      oxygenated = panels.each_index.select {|x| panels[x]==2}
      oxygenated.each do |x|
        direction.values.each do |y|
          if panels[x+y[1]*length+y[0]] == 0
            panels[x+y[1]*length+y[0]]=2
          end
        end
      end
    end

    pp count


