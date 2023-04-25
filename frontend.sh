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

PRINT "Update roboshop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.devops321.online/' -e '/user/ s/localhost/dev-user.devops321.online/' -e '/cart/ s/localhost/dev-cart.devops321.online/' -e '/shipping/ s/localhost/dev-shipping.devops321.online/' -e '/payment/ s/localhost/dev-payment.devops321.online/' /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "Enable nginx service"
systemctl enable nginx &>>$LOG
STAT $?

PRINT "Restart nginx service"
systemctl restart nginx &>>$LOG
STAT $?