path=/home/fchen/data/zhudahai
cd $path/
for i in *-*
do 
cd $path/${i}/maps2
for j  in *chr*
do
awk 'BEGIN{total=0}{total+=$3}END{print total}' $j >>${path}/${i}/count
done
done
paste ${path}/*/count >zhudahai.count
