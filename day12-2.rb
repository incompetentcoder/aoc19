require 'pry'
inp=File.open("inputday12-1").read.delete("xyz<>=").split("\n").map {|x| x.split(",").map(&:to_i)}
moons=[]
moonorigins=[]
orbits=[0,0,0]
inp.each do |x|
  moons.push(Hash.new)
  moonorigins.push(Hash.new)
  moons[-1][:position]=x
  moons[-1][:velocity]=[0,0,0]
  moonorigins[-1][:position]=x.clone
  moonorigins[-1][:velocity]=[0,0,0]
end
steps=0
while orbits.include?(0) do
  steps+=1
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
  moons.length.times do |x|
    (0..2).each do |y|
      moons[x][:position][y] += moons[x][:velocity][y]
    end
  end
  (0..2).each do |x|
    next if orbits[x] != 0
    if moons[0][:position][x] == moonorigins[0][:position][x] && moons[0][:velocity][x] == moonorigins[0][:velocity][x]
      if moons[1][:position][x] == moonorigins[1][:position][x] && moons[1][:velocity][x] == moonorigins[1][:velocity][x]
        if moons[2][:position][x] == moonorigins[2][:position][x] && moons[2][:velocity][x] == moonorigins[2][:velocity][x]
          if moons[3][:position][x] == moonorigins[3][:position][x] && moons[3][:velocity][x] == moonorigins[3][:velocity][x]
            orbits[x]=steps
          end
        end
      end
    end
  end
end

pp orbits.reduce(&:lcm)
