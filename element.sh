#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "

ERROR() {
  case $1 in
    1)  echo "Please provide an element as an argument." ;;
    2) echo "I could not find that element in the database." ;;
  esac 
}

if [[ -z $1 ]]
then
  ERROR 1
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
      RESULT=$($PSQL "SELECT symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, atomic_number FROM elements inner join properties using(atomic_number) INNER JOIN types using(type_id) WHERE elements.atomic_number = $1")
      if [[ -z $RESULT ]]
      then
        ERROR 2
      else
        SYMBOL=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\1/g')
        NAME=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\2/g')
        TYPE=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\3/g')
        ATOMIC_MASS=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\4/g')
        MELTING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\5/g')
        BOILING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\6/g')
        ATOMIC_NUMBER=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\7/g')
        MESSAGE="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
        echo $MESSAGE
      fi
  else
    if [[ $1 =~ ^[A-Z][a-z]*$ ]]
    then
      RESULT=$($PSQL "SELECT symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, atomic_number FROM elements inner join properties using(atomic_number) INNER JOIN types using(type_id) WHERE elements.name = '$1'")
      if [[ -z $RESULT ]]
      then
        RESULT=$($PSQL "SELECT symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, atomic_number FROM elements inner join properties using(atomic_number) INNER JOIN types using(type_id) WHERE elements.symbol = '$1'")
        if [[ -z $RESULT ]]
        then
          ERROR 2
        else
          SYMBOL=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\1/g')
          NAME=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\2/g')
          TYPE=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\3/g')
          ATOMIC_MASS=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\4/g')
          MELTING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\5/g')
          BOILING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\6/g')
          ATOMIC_NUMBER=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\7/g')
          MESSAGE="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
          echo $MESSAGE        
        fi
      else
        SYMBOL=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\1/g')
        NAME=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\2/g')
        TYPE=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\3/g')
        ATOMIC_MASS=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\4/g')
        MELTING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\5/g')
        BOILING_POINT=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\6/g')
        ATOMIC_NUMBER=$(echo $RESULT | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)\|(.*)/\7/g')
        MESSAGE="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
        echo $MESSAGE
      fi
    else
      ERROR 2
    fi
  fi    
fi
