
#odd or even number
read -p "enter a number: " num
if [ $((num%2)) -eq 0 ]; then
    echo "$num is even"
else
    echo "num is odd"
fi

#num positive or negative
if [ "$num" -lt 0 ]; then
    echo "num is negative"
else
    echo "num is positive"
fi

#number less greather o equal to 100
if  [ "$num" -eq 100 ]; then
    echo "num is equal than 100"
elif [ "$num" -gt 100 ]; then
    echo "num is greater than 100"
else 
    echo "num is less than 100"
fi

#check if a file exist
read -p "enter the file name: " file
if [ -f "$file" ]; then 
    echo "the file exist and is regular"
else 
    echo "your $file is not in the current working directory or either is not a regular file"
fi


read -p "enter username:" username
read -p "enter password:" password
if [[ "$username" = "Admin" && "$password" = "1234" ]]; then
    echo "access granted"
else
    echo "access negated"
fi

read -p "enter your vote: " vote
if [[ "$vote" -le 0 || "$vote" -gt 30 ]]; then
    echo "vote not valid 🙈"
elif [ "$vote" -lt 18 ]; then
    echo "sorry, you have to try again 🙉"
elif [[ "$vote" -ge 18 && "$vote" -lt 24]]; then
    echo "you passed, but you can do better 🙊"
else
    echo "congratulations, you passed with a good vote 🐵"
fi
