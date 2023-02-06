

COMPONENT=frontend
CONTENT="*"
source common.sh

PRINT "Install nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl restart nginx