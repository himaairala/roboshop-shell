COMPONENT=mongodb
source common.sh

PRINT "Download yum repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

PRINT "Install mongodb"
yum install -y mongodb-org &>>$LOG
STAT $?

PRINT "Configure mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
STAT $?

PRINT "Enable mongodb"
systemctl enable mongod &>>$LOG
STAT $?

PRINT "restart mongodb"
systemctl restart mongod &>>$LOG
STAT $?

APP_LOC=/tmp
$CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd mongodb-main &>>$LOG


PRINT "load catalogue schema"
mongo < catalogue.js &>>$LOG
STAT $?

PRINT "load users schema"
mongo < users.js &>>$LOG
STAT $?
