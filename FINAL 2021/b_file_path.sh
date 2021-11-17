FILE="$1"
 
if [[ -d $FILE ]]; then
    echo "$FILE es un directorio"
elif [[ -f $FILE ]]; then
    echo "$FILE es un archivo"
else
    echo "$FILE no es valido"
    exit 1
fi
