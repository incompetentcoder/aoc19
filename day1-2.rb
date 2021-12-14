a=File.open("inputday1-1").readlines.map {|x| x.to_i}
pp (a.collect do |x|
  fuel=0
  while (x=x/3-2) > 0
    fuel+=x
  end
  fuel
end).sum
