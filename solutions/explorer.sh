#!/bin/bash
echo "Welcome to the Interactive File and Directory Explorer!"
for file in  *;
do
     size=$(stat --printf="%s" $file)
     echo "$file ($size bytes)"
done
 
#!/bin/bash
while read -r line
        do
        if [ -z "$line" ]
        then
                break
        else
                echo -n $line | wc -c
        fi
done