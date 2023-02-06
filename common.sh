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
   curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
   STAT $?
   PRINT "Remove previous version of App"

   cd /home/roboshop &>>$LOG
   rm -rf cart &>>$LOG
   STAT $?

   PRINT " Extracting App Content"
   unzip -o /tmp/cart.zip &>>$LOG
   STAT $?


   mv cart-main cart
   cd cart

   PRINT "Install NodeJs dependencies for App"
   npm install &>>$LOG
   STAT $?
   PRINT " Configure Endpoints for SystemD Configuration"
   sed -i -e 's/REDIS_ENDPOINT/redis.himaairala/' -e 's/CATALOGUE_ENDPOINT/catalogue.himaairala/' systemd.service &>>$LOG
   STAT $?

   PRINT "Setup SystemD Service"
   mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>$LOG
   STAT $?

   PRINT "Reload SystemD"
   systemctl daemon-reload &>>$LOG
   STAT $?

   PRINT "Restart System Cart"
   systemctl restart cart &>>$LOG
   STAT $?

   PRINT " Enable cart service"
   systemctl enable cart &>>$LOG
   STAT $?
}