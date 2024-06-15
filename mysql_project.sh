#!/bin/bash
id=$(echo $UID)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
echo "script started time: $TIMESTAMP"
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
if [ $id -ne 0 ] 
then 
  echo "not a root user"
else 
  echo "root user"
fi 
VALIDATE () {
    if [ $1 -ne 0 ]
    then 
      echo -e "$2 ...installed.. $R FAILURE $N"
    else 
      echo -e "$2 ...installed..$G SUCCESS $N"
    fi  
}

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enable mysql service"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "start mysql service"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE $? "setting up root password"
