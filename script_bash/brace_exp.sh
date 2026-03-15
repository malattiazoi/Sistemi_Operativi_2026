#!/opt/homebrew/bin/bash
#Example of how it works the brace expansion
echo "Brace expansion examples:"
echo "1. Generating a sequence of numbers:"
echo {1..5}
echo "2. Generating a sequence of letters:"
echo {a..e}
echo "3. Generating a sequence with a specific increment:"
echo {1..10..2}
echo "4. Combining text with sequences:"
echo file{1..3}.txt
echo "5. Nested brace expansion:"
echo {A,B}{1,2}
echo "6. Using brace expansion in commands:"
mkdir test{1..3}
echo "Created directories: test1, test2, test3"
# Clean up created directories
rm -r test{1..3}
# End of script
#counting alphabet lecters
echo -n {a..z} | wc -w
#echo -n {a..z} | tr -d " " | wc -w; - tr is used to delete spaces