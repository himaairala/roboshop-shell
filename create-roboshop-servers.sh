#!/bin/bash

#### Change these values ###

ZONE_ID="Z06349093DDNOKRYZ0JZN"
SG_NAME="allow-all"

#############################################

env=dev

create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
  --image-id $(AMI_ID) \
  --instance-type t3.micro \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value${COMPONENT}}]" \
  --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehaviour=stop}" \
  --security-group-ids ${SGID} \
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  exit

}

##  Main Program ##

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-Devops-practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

SGID=$(aws ec2 describe-security-grous --filters Name=group-name,Values=${SG_NAME} | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

if [ -z "${SGIDID}" ]; then
  echo "Given Security Group does not exist"
  exit 1
fi

for component in catalogue cart user shipping frontend mongodb mysql rabbitmq redis dispatch; do
  COMPONENT="${COMPONENT}-${env}"
  create_ec2
done