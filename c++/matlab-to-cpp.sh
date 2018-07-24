# fix comments
sed -i 's/%/\/\//g' $1

# fix "end"
sed -i 's/end/}/g' $1

# fix "3 dots"
sed -i 's/\.\.\.//g' $1

# fix "elseif"
sed -i 's/elseif/else if/g' $1

# fix "else"
sed -i 's/else/}\nelse\n{/g' $1

# fix "error()"
sed -i 's/error(/assert(/g' $1

# remove trailing spaces
sed -i 's/[ \t]*$//' $1

