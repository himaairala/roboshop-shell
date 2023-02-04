
if [ -z "$1" ]; then
  echo Input argument Password is needed
  exit
fi
ROBOSHOP_MYSQL_PASSWORD=$1

STAT() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
    else
      echo FAILURE
      exit
      fi
}

echo -e "\e[33mDownloading MySql Repo File\e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT $?

echo -e "\e[34mDisable MySql 8 version repo\e[0m"
dnf module disable mysql -y
STAT $?

echo -e "\e[35minstall MySql\e[0m"
yum install mysql-community-server -y
STAT $?

echo -e "\e[36mEnable MySql Service\e[0m"
systemctl enable mysqld
STAT $?

echo -e "\e[32start MySql Service\e[0m"
systemctl restart mysqld
STAT $?


echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}

if [ $? -ne 0 ]
then
 echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD};" > /tmp/root-pass-sql
 DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
 cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"

fi
