PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

INPUT=$1

if [[ -z $INPUT ]]
then
	echo "Please provide an element as an argument."
  exit 0
fi

if [[ ! $INPUT =~ ^[0-9]+$ ]]
then
	ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT'")
else
	ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT")
fi

if [[ -z $ATOMIC_NUMBER ]]
then
	echo "I could not find that element in the database."
  exit 0
fi

if [[ ! $INPUT =~ ^[0-9]+$ ]]
then
	ELEMENT_DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$INPUT' OR name='$INPUT'")
else
  ELEMENT_DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$INPUT")
fi

echo "$ELEMENT_DATA" | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done

