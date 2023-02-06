COMPONENT=redis
source common.sh

PRINT "Install redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
STAT $?

PRINT "Enable redis repo 6.2 version"
dnf module enable redis:remi-6.2 -y &>>$LOG
STAT $?

PRINT "Install redis"
yum install redis -y &>>$LOG
STAT $?

PRINT "Update redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
STAT $?

PRINT "Enable redis service"
systemctl enable redis &>>$LOG
STAT $?

PRINT "Restart redis service"
systemctl restart redis &>>$LOG
STAT $?