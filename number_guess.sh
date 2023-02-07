#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c "
echo "Enter your username:"
read USERNAME
GAMES_PLAYED=0
BEST_GAME=0
SEARCH_RESULT=$($PSQL "SELECT * FROM records WHERE username = '$USERNAME'")
if [[ ! -z $SEARCH_RESULT ]]
  then
    GAMES_PLAYED=$(echo $SEARCH_RESULT | sed -E 's/(.*)\|(.*)\|(.*)/\2/')
    BEST_GAME=$(echo $SEARCH_RESULT | sed -E 's/(.*)\|(.*)\|(.*)/\3/')
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  else
    INSERT_RESULT=$($PSQL "INSERT INTO records(username, games_played, best_game) values('$USERNAME', 0, 0)")
    echo $INSERT_RESULT
    echo "Welcome, $USERNAME! It looks like this is your first time here."
fi
SECRET_NUMBER=$(( $RANDOM % 1000 +1 ))
echo "Guess the secret number between 1 and 1000:"
read GUESS

GUESS_COUNT=1
while [[ $SECRET_NUMBER != $GUESS ]]
do
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
      else
        echo "It's higher than that, guess again:"
        read GUESS
    fi
  else
    echo "That is not an integer, guess again:"
    read GUESS
  fi
  GUESS_COUNT=$(( $GUESS_COUNT + 1 ))
done
echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

# Update games played / best game
if [[ $GAMES_PLAYED == 0 ]]
  then
    UPDATE_RESULT=$($PSQL "UPDATE records SET games_played = 1, best_game = $GUESS_COUNT WHERE username = '$USERNAME'")
  else
    if [[ $GUESS_COUNT -lt $BEST_GAME ]]
    then
      UPDATE_RESULT=$($PSQL "UPDATE records SET games_played = ($GAMES_PLAYED + 1), best_game = $GUESS_COUNT WHERE username = '$USERNAME'")
    else
      UPDATE_RESULT=$($PSQL "UPDATE records SET games_played = ($GAMES_PLAYED + 1), best_game = $BEST_GAME WHERE username = '$USERNAME'")
    fi
fi
