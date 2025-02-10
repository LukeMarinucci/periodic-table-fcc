#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

inputVal=$1
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

returnType() {
  if [[ $1 == 1 ]]
  then
    echo "nonmetal"
  elif [[ $1 == 2 ]]
  then
    echo "metal"
  elif [[ $1 == 3 ]]
  then
    echo "metalloid"
  else
    echo ""
  fi
}

returnOutput() {
  symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  type_id=$($PSQL "SELECT type_id FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number=$1")
  mass=$($PSQL "SELECT atomic_mass FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number=$1")
  meltingPoint=$($PSQL "SELECT melting_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number=$1")
  boilingPoint=$($PSQL "SELECT boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number=$1")
  echo "The element with atomic number $atomicNumber is $name ($symbol). It's a $(returnType $type_id), with a mass of $mass amu. $name has a melting point of $meltingPoint celsius and a boiling point of $boilingPoint celsius."
}


atomicNumber=""

if [[ $1 =~ ^[0-9]+$ ]]
then
  atomicNumber=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
fi

if [[ -z $atomicNumber ]]
then
  atomicNumber=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  if [[ -z $atomicNumber ]]
  then
    atomicNumber=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    if [[ -z $atomicNumber ]]
    then 
      echo "I could not find that element in the database."
    else 
      returnOutput $atomicNumber
    fi
  else
    returnOutput $atomicNumber
  fi
else 
  returnOutput $atomicNumber
fi
