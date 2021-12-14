require 'pry'
require 'parallel'
$a=File.open("inputday18-1").read
length=$a.index("\n")
height=$a.length/length
$a=$a.tr("\n","").chars
doors = $a.each_with_index.find_all{|x,y| x =~ /[[:upper:]]/}.to_h
keys = $a.each_with_index.find_all{|x,y| x =~ /[[:lower:]]/}.to_h
keypos=keys.invert
start={"@" => $a.index("@")}
$multi=keys.length()-1
allk = keys.keys + ["@"]
#binding.pry

#binding.pry

pp $a.each_slice(length) {|x| pp x.join}
while (b=$a.each_index.find_all {|y| $a[y] == "." && [$a[y+1],$a[y-1],$a[y+length],$a[y-length]].count("#") == 3}).empty? == false do
  b.each {|x| $a[x]="#"}
end
c=keys.select {|x,y| x =~ /[[:lower:]]/ && [$a[y+1],$a[y-1],$a[y+length],$a[y-length]].count("#") == 3}
pp $a.each_slice(length) {|x| pp x.join}

paths = [["@",[$a.index("@")]]]
results = [[],[],5000]
loop do
  todelete=[]
  paths.each_with_index do |y,z|
    if y[1].length > results[2]
      todelete.push(z)
      next
    end
    if paths[z][0].length == keys.length+1
      todelete.push(z)
      results = [paths[z][0],paths[z][1],paths[z][1].length] if paths[z][1].length < results[2]
      next
    end
    k = y[0].clone
    d = y[1].clone
    cur = d[-1]
    binding.pry if cur.class == Array
    surrounds = [cur-1,cur+1,cur+length,cur-length]
    surrounds.delete_if do |x| 
      ($a[x] =~ /[[:upper:]]/ && (k.include?($a[x].downcase) == false)) || d.count(x) > 13 || $a[x] == "#"
    end
    case surrounds.length
    when 2
      if $a[cur] =~ /[[:lower:]]/ && $a[cur] == k[-1]
        paths[z][1].push(surrounds[0])
        paths.push([k,d+[surrounds[1]]])
      else
        nw = surrounds.select {|x| d.include?(x) == false}
        if nw.length == 0
          nw[0] = surrounds.min_by {|x| d.rindex(x)}
        end
        if $a[nw[0]] =~ /[[:lower:]]/ && d.include?(nw[0]) == false
          paths[z][0]+=$a[nw[0]]
        end
        paths[z][1].push(nw[0])
        if nw.size == 2
          paths.push([($a[nw[1]] =~ /[[:lower:]]/) ? k+$a[nw[1]] : k,d + [nw[1]]])
        end
      end
    when 1
      paths[z][1].push(surrounds[0])
    when 3,4
      if $a[cur] =~ /[[:lower:]]/ && $a[cur] == k[-1]
        old = d[-2]
        path[z][1].push(old)
        others = (surrounds - [old]).select {|x| d.include?(x) == false}
        if others != []
          others.each do |other|
            paths.push([($a[other] =~ /[[:lower:]]/) ? k+$a[other] : k,d+[other]])
          end
        end
      else
        eep = surrounds.select {|x| d.include?(x) == false}
        if eep.length > 0
          eep[1..-1].each {|x| paths.push([($a[x] =~ /[[:lower:]]/) ? k+$a[x] : k,d + [x]])}
        else
          eep[0] = surrounds.min_by {|x| d.rindex(x)}
        end
        if $a[eep[0]] =~ /[[:lower:]]/ && d.include?(eep[0]) == false
          paths[z][0]+=$a[eep[0]]
        end
        paths[z][1].push(eep[0])
      end
    when 0
      todelete.push(z)
    end
  end
  todelete.each {|x| paths.delete_at(x)}
  eep = paths.map {|x| x[0].length}
  pp eep.max,paths.length if eep.max != nil
  binding.pry if eep.max == nil
end
binding.pry

def distances(start,keys,doors,length,height)
  b=$a.clone
  dists=Hash.new
  tofind=keys.keys-[$a[start]]
  doorpos=doors.invert
  keypos=keys.invert
  count=0
  b[start]=0
  keysrequired=[]
  while tofind != []
    from=b.each_with_index.find_all{|x,y| x==count}
    count+=1
    from.each do |x,y|
      [y+1,y-1,y+length,y-length].each do |z|
        zdivmod=z.divmod(length)
        if zdivmod[0] > -1 && zdivmod[0] < (b.length/length)
          case b[z]
          when /[[A-Z]\.@]/
            b[z]=count
          when /\d/
            b[z]=count if b[z] > count
          when /[[:lower:]]/
            dists[b[z]]=Hash.new
            dists[b[z]][:count]=count.to_f
            dists[b[z]][:kreq]=[]
            dists[b[z]][:kgot]=[]
            #dists[b[z]]["KeysGotten"].push(b[z]) if b[z] =~ /[[:lower:]]/
            tofind -= [b[z]]
            zz=z
            count2=count-1
            while b[zz] != 0 do
              if b[zz-1] == count2
                zz-=1
              elsif b[zz+1] == count2
                zz+=1
              elsif b[zz+length] == count2
                zz+=length
              elsif b[zz-length] == count2
                zz-=length
              end
              count2-=1
              dists[b[z]][:kreq].push(doorpos[zz].downcase) if doorpos[zz]
              dists[b[z]][:kgot].push(keypos[zz]) if keypos[zz]
            end
            b[z]=count
          end
        end
      end
    end
  end
  return dists
end

dists=Hash.new
(start.merge(keys)).each_pair do |x,y|
  dists[x]=distances(y,keys,doors,length,height)
end

#pp dists["@"]

$totals=["test",10000]


def recursion(current,keysgotten,keys)
  if current[1] < $totals[1]
    if keys - keysgotten == []
      $totals = current
      pp current
    else
      x=current[0][-1]
      temp = (keys-keysgotten).select {|zz| current[1]+$dists2[x][zz][:count] < $totals[1]}
      if temp != []
        temp2 = temp.select {|y| ($dists2[x][y][:kreq] - keysgotten == []) && ($dists2[x][y][:kgot] - keysgotten==[]) && (keysgotten.include?(y) == false)}
        if temp2 != []
          temp2.sort_by!{|z| $dists2[x][z][:count]}
          Parallel.each(temp2.sort_by {|z| (temp2.index(z)+($lengths - ($lengths - temp2)).index(z)) }, in_threads: current[0].length == 2 ? temp2.length : 0) do |z|
            keysgotten2 = (keysgotten+[z])
            current2 = [current[0]+z,current[1]+$dists2[x][z][:count]]
            recursion(current2,keysgotten2,keys)
          end
        end
      end
    end
  end
end


#$counter=0
$dists2=dists
#$allkeys=keys.keys


#cr = [["@",0]]
#cr3 = []
#loop do
#  pp cr[0][0].length
#  pp $$totals
#  count=0
#  cr3= Parallel.map(cr, in_threads: 4) {|x| ($allkeys - x[0].chars).map {|y| [x[0]+y,x[1]+$dists2[x[0][-1]][y]["Count"]] if (x[1]+$dists2[x[0][-1]][y]["Count"]) < $$totals[0][1] && ($dists2[x[0][-1]][y]["KeysRequired"] - x[0].chars == [])}.compact}
#  #GC.start
   
#  cr.each do |x|
#    count+=1
#    ($allkeys - x[0].chars).each {|y| cr3.push([x[0]+y,x[1]+$dists2[x[0][-1]][y]["Count"]]) if (x[1]+$dists2[x[0][-1]][y]["Count"]) < $$totals[0][1] && ($dists2[x[0][-1]][y]["KeysRequired"] - x[0].chars == [])}
#    if count==cr.length/15
      #GC.start
#      count=0
#    end
#  end
#  pp cr3.length
#  cr=cr3.flatten(1).sort_by! {|x| x[1]}[0..[5000000,cr3.length/8].max]
#  cr3 = []
#  #GC.start
#  pp cr.length
#  binding.pry
#  break if cr == []
#  if cr[0][0].length > keys.length/4 && cr[0][0].length < keys.length
#    meep = (cr[0][1]/cr[0][0].length.to_f)*((keys.length+1)**(1+((keys.length+1)/cr[0][0].length.to_f)/5.0))
#    if meep < $$totals[0][1]
#      $$totals.unshift([cr[0][0],meep])
#    end
#  end
#  #GC.start
#  if cr[0][0].length == keys.length()+1
#    $$totals.unshift(cr[0])
#  end
#end





#
#
$lengths = Hash.new
keys.keys.each {|x| $lengths[x]= ((keys.keys+["@"] - [x]).collect {|y| dists[y][x][:kreq]}.flatten.length)}
$lengths = $lengths.sort_by {|x,y| y}.map {|x| x[0]}
temp = keys.keys.select {|y| dists["@"][y][:kreq] == [] && dists["@"][y][:kgot]==[]}
temp.sort_by! {|x| dists["@"][x][:count]}
Parallel.each(temp.sort_by {|z| (temp.index(z)+$lengths.index(z))}, in_threads: temp.length)  do |x|
  recursion(["@"+x,dists["@"][x][:count]],[x],keys.keys)
end

pp $totals
#binding.pry
