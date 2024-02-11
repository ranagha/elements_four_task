#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else 
  re='^[0-9]+$'
  if [[ $1 =~ $re ]] 
  then
  ELEMENT=$($PSQL "select elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type from elements, properties, types where elements.atomic_number = properties.atomic_number and properties.type_id = types.type_id and (elements.atomic_number=$1)")
  else
    ELEMENT=$($PSQL "select elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type from elements, properties, types where elements.atomic_number = properties.atomic_number and properties.type_id = types.type_id and (elements.symbol='$1' or elements.name='$1')")
  fi
  echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE
  do
    if [[ -z $ATOMIC_NUMBER ]]
    then 
        echo "I could not find that element in the database."
    else 
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  done  
fi