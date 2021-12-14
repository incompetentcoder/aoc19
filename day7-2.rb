require 'pry'

b=File.open("inputday7-1").read.split(",").map{ |x| x.to_i}

outputs=Hash.new
phases=[5,6,7,8,9].permutation.to_a.each do |x|
  dones=Hash[x.zip([0,0,0,0,0])]
  output=0
  outputs[x]=[]
  amplifier=0
  amplifierruns=[0,0,0,0,0]
  amplifiermemories=[b.clone,b.clone,b.clone,b.clone,b.clone]
  amplifierpos=[0,0,0,0,0]
  while dones.values.include? 0 do
    breaking=false
    y=x[amplifier]
    if amplifierruns[amplifier] == 0
      input=y
    else
      input=output
    end
    amplifierruns[amplifier]+=1
    mode=[0,0,0]
    ins=""

    while breaking == false do
      ins=amplifiermemories[amplifier][amplifierpos[amplifier]].to_s
      opcode=ins[ins.length-2..-1].to_i
      mode=[ins[-5].to_i,ins[-4].to_i,ins[-3].to_i]
      case opcode
      when 1
        arg0,arg1,arg2=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+3]
        amplifiermemories[amplifier][arg2]=(mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) + (mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1])
        amplifierpos[amplifier]+=4
      when 2
        arg0,arg1,arg2=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+3]
        amplifiermemories[amplifier][arg2]=(mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) * (mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1])
        amplifierpos[amplifier]+=4
      when 3
        arg0=amplifiermemories[amplifier][amplifierpos[amplifier]+1]
        amplifiermemories[amplifier][arg0]=input
        amplifierpos[amplifier]+=2
        input=output
      when 4
        arg0=amplifiermemories[amplifier][amplifierpos[amplifier]+1]
        output=mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]
        amplifierpos[amplifier]+=2
        breaking=true
      when 5
        arg0,arg1=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+2]
        (mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) != 0 ? amplifierpos[amplifier]=(mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1]) : amplifierpos[amplifier]+=3
      when 6
        arg0,arg1=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+2]
        (mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) == 0 ? amplifierpos[amplifier]=(mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1]) : amplifierpos[amplifier]+=3
      when 7
        arg0,arg1,arg2=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+3]
        (mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1]) > (mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) ? amplifiermemories[amplifier][arg2] = 1 : amplifiermemories[amplifier][arg2] = 0
        amplifierpos[amplifier]+=4
      when 8
        arg0,arg1,arg2=amplifiermemories[amplifier][amplifierpos[amplifier]+1..amplifierpos[amplifier]+3]
        (mode[1]==1 ? arg1 : amplifiermemories[amplifier][arg1]) == (mode[2]==1 ? arg0 : amplifiermemories[amplifier][arg0]) ? amplifiermemories[amplifier][arg2] = 1 : amplifiermemories[amplifier][arg2] = 0
        amplifierpos[amplifier]+=4
      when 99
        dones[y] = 1
        outputs[x].push(output) if amplifier == 4
        breaking = true
      end
    end
    amplifier=(amplifier+1)%5
  end
end
pp outputs.sort_by {|x| x[1]}.last
