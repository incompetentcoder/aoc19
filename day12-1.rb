require 'pry'
inp=File.open("inputday12-1").read.delete("xyz<>=").split("\n").map {|x| x.split(",").map(&:to_i)}
moons=[]
inp.each do |x|
  moons.push(Hash.new)
  moons[-1][:position]=x
  moons[-1][:velocity]=[0,0,0]
end

1000.times do
  (moons.length() -1).times do |a|
    (a+1...moons.length).each do |b|
      (0..2).each do |c|
        if moons[a][:position][c] > moons[b][:position][c]
          moons[a][:velocity][c] -= 1
          moons[b][:velocity][c] += 1
        elsif moons[a][:position][c] < moons[b][:position][c]
          moons[a][:velocity][c] += 1
          moons[b][:velocity][c] -= 1
        end
      end
    end
  end
  moons.each do |x|
    (0..2).each do |y|
      x[:position][y] += x[:velocity][y]
    end
  end
end
energy=0
moons.each do |x|
  energy+= x[:position].map{|y| y.abs}.reduce(:+) * x[:velocity].map{|y| y.abs}.reduce(:+)
end

pp energy
