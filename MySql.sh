echo -e "\e[33mDownloading MySql Repo File\e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FALURE
fi
echo -e "\e[34mDisable MySql 8 version repo\e[0m"
dnf module disable mysql -y

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FALURE
fi
echo -e "\e[35minstall MySql\e[0m"
yum install mysql-community-server -y

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FALURE
fi
echo -e "\e[36mEnable MySql Service\e[0m"
systemctl enable mysqld
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FALURE
fi
echo -e "\e[32start MySql Service\e[0m"
systemctl restart mysqld
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FALURE
fi

echo show databases | mysql -uroot -pRoboShop@1

if [ $? -ne 0 ]
then
 echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" > /tmp/root-pass-sql
 DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
 cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"

fi
