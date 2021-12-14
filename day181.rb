#require 'pry'
require 'parallel'
$a=File.open("inputday18-1").read
length=$a.index("\n")
$a=$a.tr("\n","").chars
doors = $a.each_with_index.find_all{|x,y| x =~ /[[:upper:]]/}.to_h
keys = $a.each_with_index.find_all{|x,y| x =~ /[[:lower:]]/}.to_h
start={"@" => $a.index("@")}

#binding.pry

def distances(start,keys,doors,length)
  b=$a.clone
  dists=Hash.new
  tofind=keys.keys+doors.keys-[$a[start]]
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
          when /[\.@]/
            b[z]=count
          when /\d/
            b[z]=count if b[z] > count
          when /[[:alpha:]]/
            dists[b[z]]=Hash.new
            dists[b[z]]["Count"]=count
            dists[b[z]]["KeysRequired"]=[]
            dists[b[z]]["KeysGotten"]=[]
            dists[b[z]]["KeysGotten"].push(b[z]) if b[z] =~ /[[:lower:]]/
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
              dists[b[z]]["KeysRequired"].push(doorpos[zz].downcase) if doorpos[zz]
              dists[b[z]]["KeysGotten"].push(keypos[zz]) if keypos[zz]
            end
            dists[b[z]]["KeysRequired"].push(b[z].downcase) if doors[b[z]]
            b[z]=count    
          end
        end
      end
    end
  end
  return dists
end

dists=Hash.new
(start.merge(keys).merge(doors)).each_pair do |x,y|
  dists[x]=distances(y,keys,doors,length)
end

$totals=[["test",10000]]

def recursion(current,keysgotten)
  if $allkeys - current[0].chars == []
    $totals.unshift(current)
    pp $totals[0]
  else
    x=current[0][-1]
    temp = ($allkeys-current[0].chars).select {|zz| current[1]+$dists2[x][zz]["Count"] < $totals[0][1]}
    if temp != []
      temp2 = temp.select {|y| $dists2[x][y]["KeysRequired"] - ($dists2[x][y]["KeysGotten"]+keysgotten) == [] && ($dists2[x][y]["KeysGotten"]-keysgotten).length == 1}
      if temp2 != []
        Parallel.each(temp2, in_threads: 2)  do |z|
          current2 = [current[0]+z,current[1]+$dists2[x][z]["Count"]]
          keysgotten2 = $dists2[x][z]["KeysGotten"] + keysgotten
          recursion(current2,keysgotten2.uniq)
        end
      end
    end
  end
end


$counter=0
$dists2=dists
$allkeys=keys.keys


temp = $allkeys.select {|y| $dists2["@"][y]["KeysRequired"] - ($dists2["@"][y]["KeysGotten"]) == [] && $dists2["@"][y]["KeysGotten"].length == 1}
Parallel.each(temp, in_threads: temp.length)  {|x| recursion(["@"+x,$dists2["@"][x]["Count"]],$dists2["@"][x]["KeysGotten"])}

#binding.pry
