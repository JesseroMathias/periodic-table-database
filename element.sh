#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

SYMBOL=$1

# Function to display element information
display_element_info() {
  echo "$1" | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
}

# Determine if input is a number or text
if [[ $SYMBOL =~ ^[0-9]+$ ]]; then
  # Search by atomic number
  DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$SYMBOL")
else
  # Determine length of SYMBOL to decide if it's a symbol or a name
  LENGTH=${#SYMBOL}
  if [[ $LENGTH -gt 2 ]]; then
    # Search by element name
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$SYMBOL'")
  else
    # Search by element symbol
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$SYMBOL'")
  fi
fi

# Display data or error message
if [[ -z $DATA ]]; then
  echo "I could not find that element in the database."
else
  display_element_info "$DATA"
fi
