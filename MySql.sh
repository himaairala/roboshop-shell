curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
dnf module disable mysql -y

yum install mysql-community-server -y

systemctl enable mysqld
systemctl restart mysqld

echo "1 c ALTER USER 'root'@'localhost' IDENTFIED BY 'RoboShop1';" > /tmp/root-pass-sql

#echo "ALTER USER 'root'@'localhost' IDENTFIED BY 'RoboShop1';" >/tmp/root-pass-sql
#DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

#cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"7g?clXdsI9o"
