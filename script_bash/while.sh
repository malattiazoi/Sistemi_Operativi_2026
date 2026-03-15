# Example script to demonstrate the use of 'while' loops in Bash
# Read every line from a file and print it with line numbers
while read -r line; do
    echo "Line: $line"
done < "/etc/passwd"  # Input file

# Simple counter using while loop
i=1
while [ $i -le 5 ]; do
    echo "Count: $i"
    ((i++))
done

#infinite loop
# while true; do
#     echo "This will run forever. Press [CTRL+C] to stop."
#     sleep 1
# done

# Read every line of a file and print it with line numbers

while read -r line; do
    echo "Line: $line"
done < setting.txt # Input file

# Tipic use to process a name and path list
read -p "Enter a value from keyborad: " value

# Example of using while loop with a condition
while [ "$value" != "exit" ]; do
    echo "You entered: $value"
    read -p "Enter a value from keyboard (type 'exit' to quit): " value
done    
echo "Exited the loop. Goodbye!"

# Example with break and continue
while true; do
    read -p "Enter a number (or 'exit' to quit): " number
    if [ "$number" = "exit" ]; then
        echo "Exiting the loop. Goodbye!"
        break
    elif ! [[ "$number" =~ ^[0-9]+$ ]]; then
        echo "That's not a valid number. Please try again."
        continue
    fi
    echo "You entered the number: $number"
done    

# Another example with break and continue
# break exits the loop you are in
# continue skips the current iteration and goes to the next one
while true; do
    read -p "Enter a word (or 'exit' to quit): " number
    [ "$number" = "exit" ] && { echo "Exiting the loop. Goodbye!"; break; }
    [ -z "$number" ] && { echo "That's not a valid number. Please try again."; continue; }
    echo "You entered the word: $number"
done
# -z test if the string is empty
# -n test if the string is not empty
# while true; do ... done creates an infinite loop
# Use break to exit the loop and continue to skip the current iteration

while IFS=',' read -r name surname years; do
    echo "Naame: $name, Surname: $surname, Is $years old"
done < elenco.csv  # Input file with comma-separated values