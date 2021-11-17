#!/bin/sh

ABC="ABCDEFGHIKLMNOPQRSTUVWXYZ"

## indica si una cadena contiene un caracter
contiene() {
    string="$1" 
    substring="$2"

    if test "${string#*$substring}" != "$string"
    then
        return 1    # contiene
    else
        return 0    # no contiene
    fi
}

## retorna la posicion de un caracter en una cadena
pos() {
  string="$1" 
  substring="$2"

  res=`expr index "$string" "$substring"`
  
  return $res
}

## genera la cuadricula
generarCuadricula(){
  clave=$1

  ## se pasa la semilla a mayusculas
  clave=${clave^^}
  
  ## la clave es vacia
  strCuadricula=""
  
  ## se añada cada caracter de la clave que no está en la cuadricula
  for (( i=0; i<${#clave}; i++ )); do
    caracter="${clave:$i:1}"
    
    contiene $strCuadricula $caracter
    
    if [ $? -eq 0 ]; then
      strCuadricula="$strCuadricula$caracter"
    fi
  
  done

  ## se añada cada caracter del ABC que no está en la cuadricula
  for (( i=0; i<${#ABC}; i++ )); do
    caracter="${ABC:$i:1}"

    contiene $strCuadricula $caracter
  
    if [ $? -eq 0 ]; then
      strCuadricula="$strCuadricula$caracter"
    fi

  done

  ## cuadricula por filas
  cuadriculaFila[1]=${strCuadricula:0:5}
  cuadriculaFila[2]=${strCuadricula:5:5}
  cuadriculaFila[3]=${strCuadricula:10:5}
  cuadriculaFila[4]=${strCuadricula:15:5}
  cuadriculaFila[5]=${strCuadricula:20:5}

  ## cuadricula por columnas
  for (( i=1; i<=5; i++ )); do
    cuadriculaCol[i]="" 
    for (( j=1; j<=5; j++ )); do
      k=`expr $i - 1`
      cuadriculaCol[i]="${cuadriculaCol[i]}${cuadriculaFila[j]:$k:1}"
    done
  done

  
}

## verifica el caso 1 y en caso positivo retorna la fila que cumple
verificarCaso1() {
  fila=1;
  for i in "${cuadriculaFila[@]}"; do
    contiene $i $1
    if [ $? -eq 1 ]; then
      contiene $i $2
      if [ $? -eq 1 ]; then
        return $fila ## cumple
      fi
    fi
    fila=`expr $fila + 1`
  done
  return 0 ## no cumple
}

## verifica el caso 2 y en caso positivo retorna la columna que cumple
verificarCaso2() {
  col=1;
  for i in "${cuadriculaCol[@]}"; do
    contiene $i $1
    if [ $? -eq 1 ]; then
      contiene $i $2
      if [ $? -eq 1 ]; then
        return $col ## cumple
      fi
    fi
    col=`expr $col + 1`
  done
  return 0 ## no cumple
}

## cifra el caso 1
cifrarCaso1() {
  fila=$1
  char=$2
  fila=${cuadriculaFila[$fila]}

  pos $fila $char
  x=`expr $? % 5`

  retval="${fila:$x:1}"
}

## descifra el caso 1
descifrarCaso1() {
  fila=$1
  char=$2
  fila=${cuadriculaFila[$fila]}

  pos $fila $char
  x=`expr $? - 2`
  
  if [ $x -lt 0 ]; then
    x=4;
  fi

  retval="${fila:$x:1}"
}

## cifra el caso 2
cifrarCaso2() {
  col=$1
  char=$2
  col=${cuadriculaCol[$col]}

  pos $col $char
  x=`expr $? % 5`

  retval="${col:$x:1}"
}

## descifra el caso 2
descifrarCaso2() {
  col=$1
  char=$2
  col=${cuadriculaCol[$col]}

  pos $col $char
  x=`expr $? - 2`
  
  if [ $x -lt 0 ]; then
    x=4;
  fi

  retval="${col:$x:1}"
}

## Auxiliar que obtiene la fila de un letra en la cuadricula
obtenerFila() {
  fila=1;
  for i in "${cuadriculaFila[@]}"; do
    contiene $i $1
    if [ $? -eq 1 ]; then
      return $fila 
    fi
    fila=`expr $fila + 1`
  done
  return 0 
}

## Auxiliar que obtiene la columna de un letra en la cuadricula
obtenerCol() {
  col=1;
  for i in "${cuadriculaCol[@]}"; do
    contiene $i $1
    if [ $? -eq 1 ]; then
      return $col 
    fi
    col=`expr $col + 1`
  done
  return 0 
}

## cifra el caso 3
## se cruzan filas y columnas 
cifrarCaso3() {
  char1=$1
  char2=$2

  obtenerFila $char1
  fila1=$?
  
  obtenerCol $char1
  col1=`expr $? - 1` 

  obtenerFila $char2
  fila2=$?
  
  obtenerCol $char2
  col2=`expr $? - 1` 

  # Fila 1 x Columna 2
  retval1=${cuadriculaFila[$fila1]:col2:1}
  
  # Fila 2 x Columna 1
  retval2=${cuadriculaFila[$fila2]:col1:1}
}

## curiosamente es el mismo algoritmo
descifrarCaso3() {
  cifrarCaso3 $1 $2
}

## auxiliar imprime la cuadricula
imprimirCuadricula() {
  echo ${cuadriculaFila[1]}
  echo ${cuadriculaFila[2]}
  echo ${cuadriculaFila[3]}
  echo ${cuadriculaFila[4]}
  echo ${cuadriculaFila[5]}
}

## auxiliar para eliminar caracteres contiguos iguales
eliminarDuplicados() {
  texto=$1
  retval=${texto:0:1}
  
  for (( i=0, j=1; j<${#texto}; i++, j++ )); do
    caracteri="${texto:$i:1}"
    caracterj="${texto:$j:1}"

    if [ $caracteri != $caracterj ]; then
      retval="$retval$caracterj"
    fi

  done
}


## cifra un mensaje
cifrar() {
  echo "cifrando, aguarde..."
  mensaje=$1
  
  # se convierte a mayusculas
  mensaje=${mensaje^^}
  
  # se acomoda el mensaje 
  # cambiando la J por la I
  mensaje=`echo "$mensaje" | tr J I`
  # cambiando la Ñ por la N
  mensaje=`echo "$mensaje" | tr Ñ N`
  
  # se eliminan los espacios
  mensaje=${mensaje// }

  # seeliminan los caracteres contiguos que son duplicados
  eliminarDuplicados $mensaje
  mensaje=$retval

  # se complementa el mensaje si tiene longitud impar
  if [ `expr ${#mensaje} % 2` -ne 0 ]; then
    mensaje="${mensaje}X"
  fi

  # para guardar el cifrado
  mcifrado=""

  for((m=0, n=m+1; m<${#mensaje}; m=m+2, n=m+1)) do
    
    # caracteres del digrama
    char1=${mensaje:$m:1}
    char2=${mensaje:$n:1}

    #verificar si es el caso 1
    verificarCaso1 $char1 $char2
    f=$?
    if [ $f -gt 0 ]; then
      #cifrar caso 1 caracter 1 
      cifrarCaso1 $f $char1
      mcifrado="$mcifrado$retval"
      
      #cifrar caso 1 caracter 2 
      cifrarCaso1 $f $char2
      mcifrado="$mcifrado$retval"
      
      #continuar con el siguiente digrama
      continue
    fi

    verificarCaso2 $char1 $char2
    c=$?
    if [ $c -gt 0 ]; then 
      
      #cifrar caso 2 caracter 1 
      cifrarCaso2 $c $char1
      mcifrado="$mcifrado$retval"
      
      #cifrar caso 2 caracter 2 
      cifrarCaso2 $c $char2
      mcifrado="$mcifrado$retval"
  
      #continuar con el siguiente digrama
      continue
    fi

    # cifrar el caso 3
    cifrarCaso3 $char1 $char2
    mcifrado="$mcifrado$retval1$retval2"

    
  done

  #retornar el cifrado
  retval="$mcifrado"
}

## descifra el mensaje... 
## es practicamente el mismo algoritmo que cifrar
## solo que no tiene que acomodar el texto
descifrar() {
  echo "descifrando, aguarde..."
  mcifrado=$1
  
  # para guardar el descifrado
  mdescifrado="" 

  for((m=0, n=m+1; m<${#mcifrado}; m=m+2, n=m+1)) do
    
    # caracteres del digrama
    char1=${mcifrado:$m:1}
    char2=${mcifrado:$n:1}

    # verificar el caso 1
    verificarCaso1 $char1 $char2
    f=$?
    if [ $f -gt 0 ]; then
      
      # descifrar caso 1 caracter 1 
      descifrarCaso1 $f $char1
      mdescifrado="$mdescifrado$retval"
      
      # descifrar caso 1 caracter 2 
      descifrarCaso1 $f $char2
      mdescifrado="$mdescifrado$retval"
      
      # continuar con el siguiente digrama 
      continue
    fi

    verificarCaso2 $char1 $char2
    c=$?
    if [ $c -gt 0 ]; then 
      
      # descifrar caso 2 caracter 1 
      descifrarCaso2 $c $char1
      mdescifrado="$mdescifrado$retval"
      
      # descifrar caso 2 caracter 2 
      descifrarCaso2 $c $char2
      mdescifrado="$mdescifrado$retval"
      
      # continuar con el siguiente digrama 
      continue
    fi

    # cifrar el caso 3
    descifrarCaso3 $char1 $char2
    mdescifrado="$mdescifrado$retval1$retval2"
    
  done

  # retornar el descifrado
  retval="$mdescifrado"
}

key="CODES"
echo "Clave: $key"
echo

echo "Cudaricula:"
echo
generarCuadricula "$key"
imprimirCuadricula 
echo

men="this is a top secret message"
echo "Mensaje: '$men'"
echo

cifrar "$men"
echo "$retval"

echo 

descifrar "$retval"
echo "$retval"

echo