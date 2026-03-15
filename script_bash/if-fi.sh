

# This script demonstrates the use of if, elif (else if), and else statements in bash

# Prompt the user to enter a number
echo "Enter a number:"
read number  # Read user input and store it in the variable 'number'

# First if statement: check if the number is greater than 20
if [ "$number" -gt 20 ]; then
    # This block runs if the number is greater than 20
    echo "The number is greater than 20."
# elif is used for 'else if' conditions
elif [ "$number" -gt 10 ]; then
    # This block runs if the number is NOT greater than 20, but is greater than 10
    echo "The number is greater than 10 but less than or equal to 20."
# You can have multiple elif blocks for more conditions
elif [ "$number" -eq 10 ]; then
    # This block runs if the number is exactly 10
    echo "The number is exactly 10."
else
    # This block runs if none of the above conditions are true
    echo "The number is less than 10."
fi  # End of the if-elif-else block

# Another example: check if the number is even or odd
if [ $((number % 2)) -eq 0 ]; then
    # $((...)) is used for arithmetic operations
    echo "The number is even."
else
    echo "The number is odd."
fi

# Final example: check if the number is positive, negative, or zero
if [ "$number" -gt 0 ]; then
    echo "The number is positive."
elif [ "$number" -lt 0 ]; then
    echo "The number is negative."
else
    echo "The number is zero."
fi

if [ -f "myfile.txt" ]; then
    echo "myfile.txt exists."
else
    echo "myfile.txt does not exist."
fi
# -f tesst if the file exists and is regular file 
# -d test if the directory exists
# -e test if the file exists (either file or directory)
# -r test if the file is readable
# -w test if the file is writable
# -x test if the file is executable
# -s test if the file is not empty
# -z test if the string is empty
# -n test if the string is not empty

#you also have the or condition with ||
if [ "$number" -lt 5 ] || [ "$number" -gt 15 ]; then
    echo "The number is either less than 5 or greater than 15."
else
    echo "The number is between 5 and 15."
fi
#you also have the and condition with &&
if [ "$number" -ge 5 ] && [ "$number" -le 15 ]; then
    echo "The number is between 5 and 15."
else
    echo "The number is either less than 5 or greater than 15."
fi
#you can also use nested if statements
if [ "$number" -ge 0 ]; then
    if [ "$number" -le 100 ]; then
        echo "The number is between 0 and 100."
    else
        echo "The number is greater than 100."
    fi
else
    echo "The number is negative."
fi

#regex matching with =~ and using the double brackets [[ ]]
#double brackets are more powerful and flexible than single brackets
string="hello123"
if [[ "$string" =~ ^hello[0-9]+$ ]]; then
    echo "The string starts with 'hello' followed by one or more digits."
else
    echo "The string does not match the pattern."
fi
#with the ! operator you can negate the condition
if ! [[ "$string" =~ ^hello[0-9]+$ ]]; then
    echo "The string does not start with 'hello' followed by one or more digits."
else
    echo "The string matches the pattern."
fi