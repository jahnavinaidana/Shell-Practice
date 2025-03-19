#!/bin/bash

source ./common.sh
check_root

echo "please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql-server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql-server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code is used to idempotency nature
mysql -h db.awsproject.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MYSQL Root password Setup"
else
    echo -e "Root password is already set...$Y SKIPPING $N"
fi