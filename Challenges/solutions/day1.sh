#!/bin/bash
# task 1 ,2
echo "Hello"
#task 3
a="Hello"
b="World!"
echo "$a,$b"
 
#task4
echo "Enter number 1"
read num1
 
echo "Enter number 2"
read num2
 
echo $(($num1 + $num2))
 
#task5
echo "My current bash path-$BASH"
echo "Bash version I am using-$BASH_VERSION"
echo "PID of bash I am running-$BASHPID"
echo "Home Directory-$HOME"
echo "Where am I rn-$PWD"
echo "My hostname-$HOSTNAME"
 

#task 6
echo "all files with txt extension:"
ls *.txt