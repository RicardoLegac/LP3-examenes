dir="$1"
 
[ $# -eq 0 ] && { echo "Usage: $0 dir-name"; exit 1; }
 
if [ -d "$dir" -a ! -h "$dir" ]
then
   echo "$dir existe"
   
else
   echo "Error: $dir  no existe."
fi
