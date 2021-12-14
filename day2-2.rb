a=File.open("inputday2-1").read.split(",").map{ |x| x.to_i}
99.times do |x|
  99.times do |y|
    b=a.clone
    b[1]=x
    b[2]=y
    b.each_slice(4) do |z|
      case z[0]
      when 1
        b[z[3]]=b[z[1]]+b[z[2]]
      when 2
        b[z[3]]=b[z[1]]*b[z[2]]
      when 99
        break
      else
        pp "shit"
      end
    end
    if b[0] == 19690720
      pp x,y,100*x+y
      exit
    end
  end
end

