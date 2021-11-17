#RICARDO LEGUIZAMON
#!/bin/bash

echo -e "ingrese palabra clave:"
read cad_clave
echo -e "ingrese que desea hacer: -c cifrado -d decifrado: "
read option 
echo 
declare  key_cad
declare  encriptar
abc="ABCDEFGHIKLMNOPQRSTUVWXYZ" #abcdario necesario segun nos conviene
if [ "$option" == -c ]
then
echo -e "cifrado\n"
#matriz_55
fi
letramatriz() {
a=$1
a=`echo $a | tr '[:lower:]' '[:upper:]'` #se convierte todo en MAYUS para comparar con 
if [ "$a" == 'J' ]
then
        a='I' #si es J es I
fi
if [ "$a" == 'Ñ' ]
then 
        a='N' #si es Ñ es N
fi
if [ `echo $abc | grep -c "$a"` -eq 0 ] #buscamos con grep caracter que no coincida con ABC
then
        return            
fi
if [ `echo ${key_cad[@]} | grep -c "$a"` -ne 0 ] #si existe la letra 
then
        return;
fi
key_cad=( ${key_cad[@]} $a )
}
matriz_55() { #print consola de la matriz generadora
        for((i=0;i<${#key_cad[@]};i++)) #nos vamos hasta la longitud de keycad
        do
        if [ `echo $i%5 | bc` -eq 0 ]
        then
                echo " "
        fi
        echo -n ${key_cad[$i]}
        done   
        echo " "
}
cifrado_mat() {
sleep 1
a=$1
for((j=0;j<${#key_cad[@]};j++))
do
        if [ "${key_cad[$j]}" == "$a" ]
        then
                return $j
        fi
done
}
for((i=1;i<=${#cad_clave};i++))
do
        cur=`echo $cad_clave | cut -c $i` 
        letramatriz $cur
done
for((i=1;i<=${#abc};i++))
do
        cur=`echo $abc | cut -c $i`
        letramatriz $cur
done
#si es impar podemos agregar una letra 
matriz_55
echo "cadena a codificar :"
read to_cod
tmp="" #variable temporal para cambiar en la matriz
for((i=1;i<=${#to_cod};i++))
do
a=`echo $to_cod | cut -c $i`
#change character to uppercase
a=`echo $a | tr '[:lower:]' '[:upper:]'`
#debemos cambiar la j por la i
if [ "$a" == 'J' ]
then
        a='I'
fi
#condicionamos para que sea todo caracteres buscamos en nuestro abc 
if [ `echo $abc | grep -c "$a"` -eq 0 ]
then
        continue
fi
if [ "$tmp" == "$a" ]
then
        continue
fi
tmp="$tmp$a"
if [ ${#tmp} -eq 2 ]
then
        encriptar=( ${encriptar[@]} $tmp )
        tmp=""
fi
done
if [ ${#tmp} -eq 1 ]
then #agregamos X
tmp=$tmp"X" 
encriptar=( ${encriptar[@]} $tmp )
fi
echo ${encriptar[*]} 
for((i=0;i<${#encriptar[@]};i++))
#esta seccion vi un codigo similar en otro lenguaje usando ficheros 
do
        char1=`echo ${encriptar[$i]} | cut -c 1` #cortamos la seccion 
        char2=`echo ${encriptar[$i]} | cut -c 2` #cortamos la seccion 
        cifrado_mat $char1
        pos1=$?
        cifrado_mat $char2
        pos2=$?
        r1=`echo "(($pos1)/5)" | bc`
        c1=`echo "(($pos1)%5)" | bc`
        r2=`echo "(($pos2)/5)" | bc`
        c2=`echo "(($pos2)%5)" | bc`
        if [ $r1 -eq $r2 ] 
        then
                c1=`echo "(($c1+1)%5)" | bc`
                c2=`echo "(($c2+1)%5)" | bc`
        elif [ $c1 -eq $c2 ] #caso igual colum
        then
                r1=`echo "(($r1+1)%5)" | bc`
                r2=`echo "(($r2+1)%5)" | bc`
        else #caso rectangulo
                tmp=$c1
                c1=$c2
                c2=$tmp
        fi
        pos1=`echo "($r1*5)+$c1" | bc`
        pos2=`echo "($r2*5)+$c2" | bc`
        char1=${key_cad[$pos1]}
        char2=${key_cad[$pos2]}
        echo -n $char1$char2
done
echo ""