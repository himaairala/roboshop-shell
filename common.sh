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

NODEJS(){
  PRINT "Install NodeJs Repos"

   curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
   STAT $?
   PRINT " Install node JS "
   yum install nodejs -y &>>$LOG
   STAT $?
   PRINT " Adding Application User"
   id roboshop &>>$LOG
   if [ $? -ne 0 ]; then
     useradd roboshop &>>$LOG
     fi
   STAT $?

   PRINT "Download App Content "
   curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
   STAT $?
   PRINT "Remove previous version of App"

   cd /home/roboshop
   rm -rf ${COMPONENT}
   STAT $?

   PRINT " Extracting App Content"
   unzip -o /tmp/${COMPONENT}.zip
   STAT $?


   mv ${COMPONENT}-main ${COMPONENT}
   cd ${COMPONENT}

   PRINT "Install NodeJs dependencies for App"
   npm install &>>$LOG
   STAT $?
   PRINT " Configure Endpoints for SystemD Configuration"
   sed -i -e 's/REDIS_ENDPOINT/redis.himaairala/' -e 's/CATALOGUE_ENDPOINT/catalogue.himaairala/' /home/roboshop/${COMPONENT}/systemd.service
   STAT $?



   PRINT "Reload SystemD"
   systemctl daemon-reload
   STAT $?

   PRINT "Restart System ${COMPONENT}"
   systemctl restart ${COMPONENT}
   STAT $?

   PRINT " Enable ${COMPONENT} "
   systemctl enable ${COMPONENT} &>>$LOG
   STAT $?
}