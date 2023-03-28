COMPONENT=rabbitmq
source common.sh

RABBITMQ_APP_USER_PASSWORD =$1

if [ ? "$1"]; then
  echo "input password is missing"
  exit
fi

PRINT "Configure erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install erlang"
yum install erlang -y &>>$LOG
STAT $?

PRINT "configure rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "install rabbitmq repos"
yum install rabbitmq-server -y &>>$LOG
STAT $?

PRINT "Enable rabbitmq server"
systemctl enable rabbitmq-server &>>$LOG
STAT $?

PRINT "Start rabbitmq server"
systemctl start rabbitmq-server &>>$LOG
STAT $?


PRINT "Add Application User "
rabbitmqctl add_user roboshop {RABBITMQ_APP_USER_PASSWORD} &>>$LOG
STAT $?

PRINT "Configure application  user  tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "Configure application  user  permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STAT $?
