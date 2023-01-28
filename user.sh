curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
rm -rf user
cd /home/roboshop
unzip -o /tmp/user.zip
mv user-main user
cd /home/roboshop/user
npm install
