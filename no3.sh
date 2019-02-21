#check if pass passed
pass=string
k=1
#mkdir /root/Documents/ss1/pw
while [ $k -lt 7 ]
do
	while
		pass="$(dd if=/dev/urandom|tr -dc A-Za-z0-9|head -c 12)"
		#check number upper and lower
		echo "$pass"
		lw=0
		up=0
		int=0
		for (( i=0; i<${#pass}; i++));
		do
			#echo "test"
			#echo "${value:i:1}"
			if [[ ${pass:i:1} =~ ^[a-z]+$ ]]
			then
				#echo "test"
				let lw=$lw+1
			fi
			if [[ ${pass:i:1} =~ ^[A-Z]+$ ]]
        	        then
				let up=$up+1
			fi
			if [[ ${pass:i:1} =~ ^[0-9]+$ ]]
        	        then
				let int=$int+1
			fi
		done
		echo $lw $up $int
		! [ $lw -gt "0" ] || ! [  $up -gt "0" ] ||  ! [ $int -gt "0" ]

	do :;done

	i=1
	file=/root/Documents/ss1/pw/password
	value=coba
	for f in $file*
	do
		value=$(<$file$i.txt)
                if test "$value" = "$pass"
                then
                        break
                fi
	done
	if test "$value" = "$pass"
        then
        	echo "ulang lagi"
		continue
        fi

	while [ -s "$file$i.txt" ]
	do
		#echo "test"
		#value=$(<$file$i.txt)
		#if test "$value" = "$pass"
		#then
		#	break
		#fi
		let i=$i+1
	done
	#if test "$value" = "$pass"
	#then
	#	echo "ulang lagi"
	#	continue
	#fi
	break
done
echo "$pass" > $file$i.txt
