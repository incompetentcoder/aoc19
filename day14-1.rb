require 'pry'
a=File.open("inputday14-1").read.split("\n").map {|x| x.split("=>")}
$b=Hash.new
a.each do |x|
  c=x[1].split(" ")
  $b[c[1]]=Hash.new
  $b[c[1]]["Amount"]=c[0]
  $b[c[1]]["Components"]=x[0].split(",").map{|y| y.split(" ")}
end
$leftovers=Hash.new
($b.keys + ["ORE"]).each {|x| $leftovers[x]=0}

$ores=0

def doit(thing,amount)
  if thing == "ORE"
    $ores+=amount.to_i-$leftovers["ORE"]
    $leftovers["ORE"]=0
  else
    $b[thing]["Components"].each do |x|
      meh = 0
      if x[1] == "ORE"
        $ores+=x[0].to_i - $leftovers["ORE"]
        $leftovers["ORE"]=0
      else
        meh=((x[0].to_f-$leftovers[x[1]])/$b[x[1]]["Amount"].to_f).ceil
        meh2=((x[0].to_f-$leftovers[x[1]])/$b[x[1]]["Amount"].to_f)
        $leftovers[x[1]] = meh*$b[x[1]]["Amount"].to_f - meh2*$b[x[1]]["Amount"].to_f
        meh.times  {doit(x[1],x[0])}
      end
    end
  end
end

doit("FUEL","1")
     
pp $ores
