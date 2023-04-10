STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo check the error in $LOG file
      exit
  fi
}
PRINT(){

  echo"---------------$1----------" >>${LOG}
  echo -e "\e[33m$1\e[0m"
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG
DOWNLOAD_APP_CODE()
{

  if [ ! -z "$APP_USER" ]; then

    PRINT " Adding Application User"
       id roboshop &>>$LOG
       if [ $? -ne 0 ]; then
         useradd roboshop &>>$LOG
         fi
       STAT $?
  fi
  PRINT "Download App Content "
     curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG
     STAT $?
     PRINT "Remove previous version of App"

     cd $APP_LOC &>>$LOG
     rm -rf $CONTENT &>>$LOG
     STAT $?

     PRINT " Extracting App Content"
     unzip -o /tmp/$COMPONENT.zip &>>$LOG
     STAT $?
}
NODEJS(){
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  APP_USER=roboshop
  PRINT "Install NodeJs Repos"

   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
   STAT $?
   PRINT " Install node JS "
   yum install nodejs -y &>>$LOG
   STAT $?


DOWNLOAD_APP_CODE


   mv ${COMPONENT}-main ${COMPONENT}
   cd ${COMPONENT}


PRINT "Install NodeJs dependencies for App"
npm install &>>$LOG
STAT $?

SYSTEMD_SETUP
}

SYSTEMD_SETUP() {
  PRINT "Configure Endpoints for SystemD Configuration"
  sed -i -e 's/MONGO_DNSNAME/dev-mongodb.devops321.online/' -e 's/REDIS_ENDPOINT/dev-redis.devops321.online/' -e 's/CATALOGUE_ENDPOINT/dev-catalogue.devops321.online/' -e 's/MONGO_ENDPOINT/dev-mongodb.devops321.online/' -e 's/CARTENDPOINT/dev-cart.devops321.online/' -e 's/DBHOST/dev-mysql.devops321.online/' -e 's/AMQPHOST/dev-rabbitmq.devops321.online/' -e 's/CARTHOST/dev-cart.devops321.online/' -e 's/USERHOST/dev-user.devops321.online/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG

  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  STAT $?

  PRINT "Restart ${COMPONENT}"
  systemctl daemon-reload &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
  STAT $?
}

JAVA()
{
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  APP_USER=roboshop

  PRINT " Install maven "
  yum install maven -y &>>$LOG
  STAT $?




   DOWNLOAD_APP_CODE
    mv ${COMPONENT}-main ${COMPONENT}
    cd ${COMPONENT}


  PRINT " Download maven dependencies"
  mvn clean package &>>$LOG  && mv target/$COMPONENT-1.0.jar $COMPONENT.jar &>>$LOG
  STAT $?



  SYSTEMD_SETUP
}

PYTHON()
{
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  APP_USER=roboshop

  PRINT "Install python "
  yum install python36 gcc python3-devel -y &>>$LOG
  STAT $?

   DOWNLOAD_APP_CODE
      mv ${COMPONENT}-main ${COMPONENT}
      cd ${COMPONENT}

PRINT "Install python dependencies"
pip3 install -r requirements.txt &>>$LOG
STAT $?
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/uid/ c uid = ${USER_ID}" -e "/uid/ c uid = ${GROUP_ID}" ${COMPONENT}.ini

SYSTEMD_SETUP
}

GOLANG()
{
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  APP_USER=roboshop

  PRINT "Install golang "
  yum install golang -y &>>$LOG
  STAT $?

   DOWNLOAD_APP_CODE
        mv ${COMPONENT}-main ${COMPONENT}
        cd ${COMPONENT}

  PRINT ""
  go mod init ${COMPONENT}
  STAT $?

  PRINT "Creating new go module"
  go get
  STAT $?

  PRINT "build golang"
  go build
  STAT $?

  SYSTEMD_SETUP

}