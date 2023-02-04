source common.sh

PRINT "Install NodeJs Repos"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
STAT $?
PRINT " Install node JS "
yum install nodejs -y
STAT $?
PRINT " Adding Application User"
useradd roboshop
STAT $?

PRINT "Download App Content "
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
STAT $?
PRINT "Remove previous version of App"

cd /home/roboshop
rm -rf cart
STAT $?

PRINT " Extracting App Content"
unzip -o /tmp/cart.zip
STAT $?


mv cart-main cart
cd cart

PRINT "Install NodeJs dependencies for App"
npm install
STAT $?
PRINT " Configure Endpoints for SystemD Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.himaairala/' -e 's/CATALOGUE_ENDPOINT/catalogue.himaairala/' systemd.service
STAT $?

PRINT "Setup SystemD Service"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
STAT $?

PRINT "Reload SystemD"
systemctl daemon-reload
STAT $?

PRINT "Restart System Cart"
systemctl restart cart
STAT $?

PRINT " Enable cart service"
systemctl enable cart
STAT $?