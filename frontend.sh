

COMPONENT=frontend
CONTENT="*"
source common.sh

PRINT "Install nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE
mv frontend-main/static/* . &>>$LOG

PRINT "copy roboshop configuration file"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT $?

PRINT "Enable nginx service"
systemctl enable nginx &>>$LOG
STAT $?

PRINT "Restart nginx service"
systemctl restart nginx &>>$LOG
STAT $?