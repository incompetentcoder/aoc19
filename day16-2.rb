require 'pry'
require 'benchmark'
time=Benchmark.realtime do
a=File.open("inputday16-1").read.chomp.chars.map(&:to_i)
a*=10000
offset=a[0..6].join.to_i
#actuala is only the part of the input we care about: from offset to end, length its length
actuala=a[offset..-1]
lenactual=actuala.length

proper = actuala.clone

proper2 = [0]*lenactual
proper3=0

100.times do |runs|
  proper2.fill(0)
#our phases here denoted by x
  lenactual.times do |x|
    if x == 0
#the first phase we take the sum of all the actuala
      proper2[x] = proper.sum
    else
#the rest of the phases we take the result of the last phase and substract currentphase position in the input from it
      proper2[x] = proper3 - proper[x-1]
    end
#we store the last result in proper3 because we have to abs the result before storing it for the next phase
    proper3=proper2[x]
    proper2[x] = proper2[x] % 10
  end
  (proper=proper2.clone)
#  pp runs
end
pp proper2[0..7]
end
pp time

