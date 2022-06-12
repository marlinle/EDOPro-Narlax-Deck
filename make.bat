ygofab make
cp expansions/* .
ygofab compose -Pall -Eall
rm -r pics/field
mv pics/EDOPro/* pics/
rmdir pics/EDOPro