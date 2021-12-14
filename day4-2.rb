require 'pp'
results1=0
results2=0
(245318..765747).each do |x|
  a=x.to_s.chars
  if a.sort == a
    if a.join.match /((.)\2)/
      results1+=1
      if a.map {|y| a.count(y)}.include?(2)
        results2+=1
      end
    end
  end
end

pp results1
pp results2
