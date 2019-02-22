# Nomor 1
Untuk mendekrip file-file yang diminta, terlebih dahulu diunzip
```bash
unzip nature.zip #ganti nature.zip sesuai dengan lokasi nature.zip di komputer masing-masing
```
Agar gampang dan tidak perlu menuliskan berulang-ulang, simpan _path_ ke shell variabel
```bash
Files=/root/Documents/ss1/nature/* 	#path dari file
target=/root/Documents/ss1/naturedc	#path dari folder berisi file yang sudah didekrip
```
Untuk mendekrip semua file yang ada, berikut potongan kodingannya
```bash
for f in $Files
do
	chmod 777 $f
	echo "ganti permision"
	base64 -d $f | xxd -r > $target/$i.jpg
	echo "1 file decrypt"
	let i=$i+1
done
```
Pendekripsian terjadi di bagian __base64 -d $f | xxd -r > $target/$i.jpg__

Setiap gambar akan didekode (__-d__) menggunakan __Base64__, di pipe menuju __xxd__, dan direverse
(__-r__) untuk dijadikan gambar kembali (__> $target/$1.jpg__)

Sedangkan untuk cronjobnya (silahkan pathnya diganti sesuai komputer masing-masing)
```
14 14 14 2 * /bin/bash soal1.sh
0 0 * 2 5 /bin/bash soal1.sh
```

# Nomor 2
### Bagian 2A
Untuk menghitung negara dengan penjualan terbanyak di tahun 2012, digunakan _associative array_
dengan nama negara (kolom 1) sebagai _subscript_ dan array tersebut berisi total penjualan negara.

_command_ pertama,
```bash
awk -F, '$7 ~ /2012/ { country[$1] += $10 }
	END {
		for (i in country) {
			print i "," country[i]
		}
	}' WA_Sales_Products_2012-14.csv
```
mencari 2012 di kolom ketujuh (__$7 ~ /2012/__), 
jika ada maka tambahkan kuantitas (__$10__) ke array negara tersebut (__country[$1]__).
Jika sudah selesai dihitung, _print_ dengan format `nama negara,kuantitas`

_command_ kedua,
```bash
sort -t, -k2rn
```
mengurutkan negara berdasarkan jumlah kuantitasnya dari yang terbanyak (__-k2rn__).

_command_ ketiga,
```bash
awk -F, 'NR == 1 { print $1 }'
```
print kolom pertama (__$1__) baris pertama (__NR == 1__), Hasilnya `United States`

### Bagian 2B
Untuk menghitung 3 _product line_ dengan kuantitas terbanyak, digunakan cara yang sama,
yang berbeda hanya syarat pencarian dan print akhir

_command_ pertama diganti menjadi
```bash
awk -F, '$1 ~ /United States/ && $7 ~ /2012/ { productline[$4] += $10 }
	END {
		for (i in productline) {
			print i "," productline[i]
		}
	}' WA_Sales_Products_2012-14.csv
```
dan _command_ ketiga diganti menjadi
```bash
awk -F, 'NR <= 3 { print $1 }'
```
untuk _print_ 3 baris teratas, hasilnya `Personal Accessories,Camping Equipment,Outdoor Protection`

### Bagian 2C
Bagian C juga sama, hanya menambah syarat pencarian

_command_ pertama,
```bash
awk -F, '$1 ~ /United States/ && ($4 ~ /Personal Accessories/ || $4 ~ /Camping Equipment/ || $4 ~ /Outdoor Protection/) && $7 ~ /2012/ {
		product[$6] += $10
	}
	END {
		for (i in product) {
			print i "," product[i]
		}
	}' WA_Sales_Products_2012-14.csv
```
dan _command_ ketiga,
```bash
awk -F, 'NR <= 3 { print $1 }'
```
hasilnya `Zone,TrailChef Water Bag,Single Edge`

# Nomor 3
Password acak ini menggunakan /dev/urandom. untuk mendapatkan password, dijalankan
```bash
/dev/urandom|tr -dc A-Za-z0-9|head -c 12
```
kemudian di _translate_ untuk mengambil huruf besar, huruf kecil, dan angka saja (__tr -dc A-Za-z0-9__).
kemudian ambil 12 karakter (__head -c 12__)

Untuk memastikan setiap password mengandung huruf besar, huruf kecil, dan angka, maka dilakukan pengecekan
```bash
if [[ ${pass:i:1} =~ ^[a-z]+$ ]] #Cek huruf kecil
	then
		let lw=$lw+1
fi
if [[ ${pass:i:1} =~ ^[A-Z]+$ ]] #Cek huruf besar
    then
	let up=$up+1
fi
if [[ ${pass:i:1} =~ ^[0-9]+$ ]] #Cek angka
    then
	let int=$int+1
fi
```
Jika _lw_ atau _up_ atau _int_ ada yang 0, maka generate password lagi.

Untuk memastikan tidak ada password yang sama, maka ada pengecekan lagi
```bash
file=/root/Documents/ss1/pw/password #Lokasi file password
for f in $file*
do
	echo "$f"
	value=$(<$f)
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
```
Jika password lolos semua pengecekan, maka tinggal diredirect ke file.

# Nomor 4
### Enkripsi
Nomor 4 dasarnya adalah _caesar cipher_ dengan jam pada saat script dijalankan sebagai key, 
dan implementasinya sebagai berikut
```bash
#Definisi fungsi
chr() {
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")"
}

ord() {
	LC_CTYPE=C printf '%d' "'$1"
}
```
Algoritma enkripsi
```bash
#mencari kode ASCII dari suatu karakter, value adalah isi dari syslog, dan i adalah iteratornya
num=`ord ${value:i:1};`

if [ $num -lt 65 ] || [ $num -gt 122 ] #Karakter selain huruf
	then
		enc="$enc${value:i:1};"

elif [ $num -ge 65 ] && [ $num -le 90 ] #Huruf besar
	then
		let "num=num-64"
		let "num=num+jam"
		if [ $num -gt 25 ] #Lebih dari 'Z', ulangi dari 'A'
			then
				let "num=num-25"
		fi
		let "num=num+64"
		enc="$enc`chr $num`"

elif [ $num -ge 97 ] && [ $num -le 122 ] #Huruf kecil
	then
		let "num=num-96"
		let "num=num+jam"
		if [ $num -gt 25 ] #Lebih dari 'z', ulangi dari 'a'
			then
				let "num=num-25"
		fi
		let "num=num+96"
		enc="$enc`chr $num`"
		echo $enc > "$fname".txt
fi
```
Algoritma diatas dijalankan berulang-ulang sebanyak panjangnya _syslog_

Untuk penamaan file, maka digunakan _date_.
```bash
jam="`date +\"%H\"`"
menit="`date +\"%M\"`"
tanggal="`date +\"%d\"`"
bulan="`date +\"%m\"`"
tahun="`date +\"%Y\"`"

fname="$jam:$menit $tanggal-$bulan-$tahun" #Path sesuaikan dengan komputer masing-masing
```
Sedangkan untuk cronjobnya (silahkan pathnya diganti sesuai komputer masing-masing)
```
0 * * * * /bin/bash soal4.sh
```

### Dekripsi
Untuk mendekripsi, prosesnya hanya perlu dibalik, yang perlu dilakukan pertama yaitu 
mengekstrak jam dari nama file
```bash
read fname
if [[ ${fname:2:1} =~ ^[0-9]+$ ]]
	then
		jam="${fname:1:1}${fname:2:1}"
fi
```
Kemudian dijalankan proses dekripsi (Fungsi sama seperti enkripsi)
```bash
num=`ord ${value:i:1};`

if [ $num -lt 65 ] || [ $num -gt 122 ]
	then
		enc="$enc${value:i:1};"
elif [ $num -ge 65 ] && [ $num -le 90 ]
	then
		let "num=num-64"
		let "num=num-jam"
   		if [ $num -lt 0 ]
    		then
      			let "num=num+25"
   		fi
   		let "num=num+64"
   		enc="$enc`chr $num`"

elif [ $num -ge 97 ] && [ $num -le 122 ]
  	then
 	   let "num=num-96"
 	   let "num=num-jam"
		if [ $num -lt 0 ]
			then
				let "num=num+25"
		fi
		let "num=num+96"
		enc="$enc`chr $num`"
		echo $enc > "dc".txt
fi
```
Hasil dekripsi diredirect ke file _dc.txt_

# Nomor 5
Nomor 5 cukup 2 baris
```bash
mkdir /home/$USER/modul1
cat /var/log/syslog | awk '/cron/ && !/sudo/' | awk 'NF < 13' >> /home/$USER/modul1/$(date +%Y%m%d%H%M%S).log
```
Penjelasannya,
```bash
cat /var/log/syslog
```
concatenate file /var/log/syslog ke stdout, kemudian di pipe ke
```bash
awk '/cron/ && !/sudo/'
```
untuk mencari records yang mengandung cron tapi tidak mengandung sudo. Kemudian di pipe lagi ke
```bash
awk 'NF < 13'
```
untuk mencari records yang memiliki jumlah _field_ kurang dari 13.

Hasilnya di redirect ke `/home/$USER/modul1/$(date +%Y%m%d%H%M%S).log`

Untuk cronjobnya (sesuaikan pathnya)
```
2-30/6 * * * * /bin/bash soal5.sh
```