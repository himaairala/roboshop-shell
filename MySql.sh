
if [ -z "$1" ]; then
  echo Input argument Password is needed
  exit
fi

COMPONENT=mysql
source common.sh
ROBOSHOP_MYSQL_PASSWORD=$1



PRINT "Downloading MySql Repo File"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
STAT $?

PRINT "Disable MySql 8 version repo"
dnf module disable mysql -y &>>$LOG
STAT $?

PRINT "install MySql"
yum install mysql-community-server -y &>>$LOG
STAT $?

PRINT "Enable MySql Service"
systemctl enable mysqld &>>$LOG
STAT $?

PRINT "start MySql Service"
systemctl restart mysqld &>>$LOG
STAT $?


echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG

if [ $? -ne 0 ]
then
 echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD};" > /tmp/root-pass-sql
 DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
 cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" &>>$LOG

fi
