#!/bin/bash

echo 'Nomor 2A'
awk -F, '$7 ~ /2012/ { country[$1] += $10 }
	END {
		for (i in country) {
			print i "," country[i]
		}
	}' WA_Sales_Products_2012-14.csv | sort -t, -k2rn | \
awk -F, 'NR == 1 { print $1 }'
echo
echo 'Nomor 2B'
awk -F, '$1 ~ /United States/ && $7 ~ /2012/ { productline[$4] += $10 }
	END {
		for (i in productline) {
			print i "," productline[i]
		}
	}' WA_Sales_Products_2012-14.csv | \
sort -t, -k2rn | \
awk -F, 'NR <= 3 { print $1 }'
echo
echo 'Nomor 2C'
awk -F, '$1 ~ /United States/ && ($4 ~ /Personal Accessories/ || $4 ~ /Camping Equipment/ || $4 ~ /Outdoor Protection/) && $7 ~ /2012/ {
		product[$6] += $10
	}
	END {
		for (i in product) {
			print i "," product[i]
		}
	}' WA_Sales_Products_2012-14.csv | \
sort -t, -k2rn | \
awk -F, 'NR <= 3 { print $1 }'