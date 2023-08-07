#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND W O WG OG
do
  if [[ $YEAR != "year" ]]
  then
    OTID=$($PSQL "SELECT team_id FROM teams WHERE name='$O'")

    WTID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")

    if [[ -z $OTID ]]
    then
      INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$O')");
      if [[ INSERT_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $O
      fi
      OTID=$($PSQL "SELECT team_id FROM teams WHERE name='$O'")
    fi

    if [[ -z $WTID ]]
    then
      INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$W')")
      if [[ INSERT_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $W
      fi
      WTID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")
    fi
    
    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WTID, $OTID, $WG, $OG)")
    
    if [[ INSERT_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted into games
    fi
  fi
done
