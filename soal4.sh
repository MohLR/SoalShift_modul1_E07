chr() {
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")"
}

ord() {
	LC_CTYPE=C printf '%d' "'$1"
}

jam="`date +\"%H\"`"
menit="`date +\"%M\"`"
tanggal="`date +\"%d\"`"
bulan="`date +\"%m\"`"
tahun="`date +\"%Y\"`"

fname="/root/Documents/ss1/$jam:$menit $tanggal-$bulan-$tahun"
#echo "$fname"

value=$(<'/var/log/syslog')
#echo $value
for (( i=0; i<${#value}; i++));
do
	#echo "${#value}"
	num=`ord ${value:i:1};`
	#echo $num
	if [ $num -lt 65 ] || [ $num -gt 122 ]
	then
		enc="$enc${value:i:1};"
	elif [ $num -ge 65 ] && [ $num -le 90 ]
	then
		let "num=num-64"
		let "num=num+jam"
   	if [ $num -gt 25 ]
    	then
      		let "num=num-25"
    	fi
    	let "num=num+64"
    	enc="$enc`chr $num`"
  	#echo $num
  	elif [ $num -ge 97 ] && [ $num -le 122 ]
  	then
 	   let "num=num-96"
 	   let "num=num+jam"
	if [ $num -gt 25 ]
 	then
     		let "num=num-25"
    	fi
    	let "num=num+96"
    	enc="$enc`chr $num`"
	#terlalu lambat bro jadi di append pelan2 aja
	echo $enc > "$fname".txt
fi
done
#echo $enc