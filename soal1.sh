unzip nature.zip
Files=/root/Documents/ss1/nature/*
mkdir /root/Documents/ss1/naturedc
target=/root/Documents/ss1/naturedc
i=0
for f in $Files
do
	chmod 777 $f 
	echo "ganti permision"
	#temp=hexdump $f
	#echo jadiin hexa
	base64 -d $f | xxd -r > $target/$i.jpg
	echo "1 file decrypt"
	let i=$i+1
done
zip naturedc.zip $target/*
rm -r $target
rm -r /root/Documents/ss1/nature
