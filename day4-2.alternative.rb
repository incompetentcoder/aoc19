require 'pp'
results1=0
results2=0
("2".."7").each do |i|
  (i.."9").each do |ii|
    (ii.."9").each do |iii|
      (iii.."9").each do |iiii|
        (iiii.."9").each do |iiiii|
          (iiiii.."9").each do |iiiiii|
            a=[i,ii,iii,iiii,iiiii,iiiiii]
            b=a.join.to_i
            if b > 245317
              if b > 765747
                pp results1,results2
                exit
              end
              c=a.map {|y| a.count(y)}
              if c.max > 1
                results1+=1
                if c.include?(2)
                  results2+=1
                end
              end
            end
          end
        end
      end
    end
  end
end
