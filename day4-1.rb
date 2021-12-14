require 'pp'
results=0
(245318..765747).each do |x|
  a=x.to_s.chars
  if a.sort == a
    if a.join.match /((.)\2)/
      results+=1
    end
  end
end

pp results
