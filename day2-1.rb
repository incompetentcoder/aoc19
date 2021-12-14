a=File.open("inputday2-1").read.split(",").map{ |x| x.to_i}
a[1]=12
a[2]=2
a.each_slice(4) do |x|
  case x[0]
  when 1
    a[x[3]]=a[x[1]]+a[x[2]]
  when 2
    a[x[3]]=a[x[1]]*a[x[2]]
  when 99
    pp "done"
    break
  else
    pp "shit"
  end
end
pp a[0]

