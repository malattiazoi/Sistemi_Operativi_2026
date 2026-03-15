
# Example script to demonstrate the use of 'for' loops in Bash

echo "1. Looping through a list of values:"
for color in red green blue; do
    echo "Color: $color"
done


echo "2. Looping through a range of numbers (using brace expansion):"
for i in {1..5}; do
    echo "Number: $i"
done

echo "2.1 Looping through a range of numbers (using brace expansion) forward and backward"
for i in {1..10..2}; do
    echo "Number: $i"
done

echo "3. Looping with C-style syntax:"
for ((i=0; i<5; i++)); do
    echo "C-style loop, i = $i"
done

echo
echo "4. Looping over files in a directory:"
for file in /etc/*.conf; do
    echo "Found config file: $file"
done

echo
echo "5. Looping through command output:"
for user in $(cut -d: -f1 /etc/passwd | head -3); do
    echo "User: $user"
done

# End of script

for percorso in $(find . -maxdepth 1 -type f); do
    echo "$percorso"
done
#search only in the current directory (-maxdepth 1) for regular files (-type f)

#array cicles
names=("Alice" "Bob" "Charlie")
for n in $(names[@]); do
    echo "Name: $n"
done

#array showing cicles
for i n "${!names[@]}"; do
    echo "Index: $i, Name: ${names[$i]}"
done

#manually making the brace expansion
for i in {1..3}; do
    for j in {a..c}; do
        echo "Combination: $i$j"
    done
done    

#cicle with continue and break
for i in {1..10}; do
    if (( i == 3 )); then
        echo "Skipping number 3"
        continue
    fi
    if (( i == 7 )); then
        echo "Breaking at number 7"
        break
    fi
    echo "Number: $i"
done
#continue skips the current iteration, break exits the loop entirely