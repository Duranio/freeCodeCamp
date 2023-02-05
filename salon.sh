#!/bin/bash
PSQL=$(echo "psql --username=freecodecamp --dbname=salon --tuples-only -X -c ")
MAIN_MENU(){
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  
  SERVICE_RESULT=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo $SERVICE_RESULT
  if [[ -z $SERVICE_RESULT ]]
  then
    MAIN_MENU
  else
    echo -e "\nEnter your phone number"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nEnter your name"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
    echo -e "\nEnter a time"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
    echo "I have put you down for a$SERVICE_RESULT at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

HAIR(){
  echo "You have chosen Hair"
}

MAIN_MENU
