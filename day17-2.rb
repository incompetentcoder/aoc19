require 'pry'
require 'set'

a=File.open("inputday17-1").read.split(",").map{ |x| x.to_i}
a+=[0]*10000
  output=0
  outputs=[]
    pos=0
    rb=0
    input=1
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
      when 4
        output=mode[2]==1 ? arg0 : a[rpos[2]]
        outputs.push(output.chr)
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
    view = outputs.join
    length = view.index("\n")+1
    start=view.index(/[\^><v]/)
    dir=view[start]
    dirs=["^",">","v","<"]
    dirsstep = [-length, +1, +length, -1]
    temp = outputs.each_index.select {|x| x > length && x < length*(length-2) && outputs[x-1]+outputs[x]+outputs[x+1]+outputs[x-length]+outputs[x+length] == "#####"} 
    intersections=temp.length
    pp temp.map {|x| (x.divmod(length)).reduce(&:*)}.sum
    tovisit=temp.length+view.count("#")

    dir=dirs.index(dir)
    robopos=start
    movs=[]
    loop do
      count=0
      while outputs[robopos+dirsstep[dir]] == "#"
        count+=1
        robopos+=dirsstep[dir]
      end
      movs.push(count) if count > 0
      if outputs[robopos+dirsstep[(dir-1)%4]] == "#"
        dir = (dir-1)%4
        movs.push("L")
      elsif outputs[robopos+dirsstep[(dir+1)%4]] == "#"
        dir = (dir+1)%4
        movs.push("R")
      else
        break
      end
    end
   
    temp=movs.join(",")
    slices=[]
    while temp =~ /[A-Z]/ do
      temp2 = temp.scan(/(?=(.+)\1)/).map {|x| x[0].delete_prefix(",").chomp(",").lstrip.rstrip}.uniq.reject {|x| x.length > 20 || x.include?(" ")}.sort_by {|x| x.length}
      break if temp2 == nil
      slices.push(temp.scan(temp2[-1]).length,temp2[-1])
      temp.gsub!(/,?#{temp2[-1]},?/," ")
      temp = temp.lstrip.rstrip
    end

    commands=[]
    slices.each {|x| commands.push(x) if x.class == String}
    commands=(("A".."Z").first(commands.length)).zip(commands).to_h
    mainroutine=[]
    temp=movs.join(",")
    while temp != "" do
      command=commands.select{|x,y| temp.index(y) == 0}
      mainroutine.push(command.keys[0])
      temp.sub!(/,?#{command.values[0]},?/,"")
    end

    mainroutine = mainroutine.join(",")+"\n"
    commands.keys.each {|x| commands[x]+="\n"}



a=File.open("inputday17-1").read.split(",").map{ |x| x.to_i}
a+=[0]*10000
a[0]=2
  output=0
  outputs=[]
    pos=0
    rb=0
    input=[mainroutine,*commands.values,"n\n"]
    input = input.map {|x| x.chars.map {|y| y.ord}}.flatten
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
        a[rpos[2]]=input.shift
        pos+=2
      when 4
        output=mode[2]==1 ? arg0 : a[rpos[2]]
        outputs.push(output)
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

    
    pp outputs.last
    
