#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
#due to a stupid bug which cost me hours, the code had to be edited... severely
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]] && [[ $ROUND != "ROUND" ]] &&  [[ $WINNER != "winner" ]] && [[ $OPPONENT != "opponent" ]] && [[ $WINNER_GOALS != "winner_goals" ]] && [[ $OPPONENT_GOALS != "opponent_goals" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      #INSERT_WINNER=
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #if [[ $INSERT_WINNER = "INSERT 0 1" ]]
      #then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        #echo Inserted $WINNER into teams
      #fi
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      #INSERT_OPPONENT=
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #if [[ $INSERT_OPPONENT = "INSERT 0 1" ]]
      #then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        #echo Inserted $OPPONENT into teams
      #fi
    fi

    #GAMES_INSERT=
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    #if [[ $GAMES_INSERT = "INSERT 0 1" ]]
    #then
      #echo Inserted $ROUND of $YEAR, $WINNER $WINNER_GOALS:$OPPONENT_GOALS $OPPONENT into games
    #fi
  fi
done
