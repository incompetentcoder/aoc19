require 'pry'
a=File.open("inputday18-1").read.chomp
length=a.index("\n")
height=a.length/length
a=a.tr("\n","").tr("@",",").chars
doors = a.each_with_index.find_all{|x,y| x =~ /[[:upper:]]/}.to_h
keys = a.each_with_index.find_all{|x,y| x =~ /[[:lower:]]/}.to_h
keypos=keys.invert
start={"," => a.index(",")}
multi=keys.length()-1
allk = (keys.keys + [","]).sort
allkl = allk.length

pp a.each_slice(length) {|x| pp x.join}
while (b=a.each_index.find_all {|y| a[y] == "." && [a[y+1],a[y-1],a[y+length],a[y-length]].count("#") == 3}).empty? == false do
  b.each {|x| a[x]="#"}
end
pp a.each_slice(length) {|x| pp x.join}
nodes=[]
a.length.times { nodes.push(Hash.new)}

toadd=[]
paths = [[[","],a.index(","),0,[","].sort]]
toadd.push(paths[0])
results = [[[]],[],6000]
count=0
loop do
  count+=1
  paths.each do |y|
    if y[2] > results[2]
      next
    end
    if y[0].length == allkl
      if y[2] < results[2]
        pp y
        exit
      end
    end
    k = y[0].clone
    d = y[1]
    ind = y[2]
    cur = y[1]
    surrounds2 = [cur-1,cur+1,cur+length,cur-length]
    surrounds = []
    surrounds2.each do |x|
      if a[x] != "#"
        if a[x] =~ /[[:upper:]]/
          if k.include?(a[x].downcase)
            surrounds.push(x)
          end
        else
          surrounds.push(x)
        end
      end
    end
    surrounds.each do |x|
      eep = (a[x] =~ /[[:lower:]]/ && k.include?(a[x])==false) ? k+[a[x]] : k
  #    if (ind+1)/(eep.length) < 200
      toadd.push([eep,x,ind+1,eep.sort.join.to_sym])
  #    end
    end
  end
  paths.clear
  while (b=toadd.pop)
    unless nodes[b[1]][b[3]]
      nodes[b[1]][b[3]] = b[2]
      paths.push(b)
    end
  end
  if count%100==0
    pp paths.length,paths.max_by {|x| x[0].length}[0].join,count
  end
  pp results if results[2] != 6000
end

