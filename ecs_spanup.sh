#!/bin/bash

#Source the environment
SOURCE_FILE=./ecs_spanup.env
source $SOURCE_FILE

#LOGFILE for all output
IAM=`whoami`
THIS_SCRIPT=`basename $0`
LOGFILE=/tmp/$IAM.$THIS_SCRIPT.log
echo $LOGFILE
#temp logfile for work
TMPFILE=/tmp/$IAM.$THIS_SCRIPT.$$.tmp
echo $TMPFILE
echo

#Cleanups on exit
#trap "rm -f $TMPFILE" EXIT 1 2 15

DATE=`date`

echo "Start of new run of $THIS_SCRIPT at $DATE" >> $LOGFILE

########################################### Start of the AWS EC2 Commands for creation and setup of VPC
#create the VPC
echo Create the VPC
echo aws ec2 create-vpc --cidr-block $VPC_CIDR_BLOCK | tee $TMPFILE 
cat $TMPFILE >> $LOGFILE

aws ec2 create-vpc --cidr-block $VPC_CIDR_BLOCK | tee $TMPFILE
cat $TMPFILE >> $LOGFILE

echo ECS_VPC_ID must be collected from the output above | tee -a $LOGFILE
ECS_VPC_ID=`grep VpcId $TMPFILE | awk -F\" '{print $4}'`
echo

#Wait for the VPC to be available
echo Wait for the VPC to be available | tee -a $LOGFILE
sleep 2
aws ec2 wait vpc-available --vpc-ids $ECS_VPC_ID | tee -a $LOGFILE
RC=$?

if [ $RC -eq 255 ]
then
	echo The VPC $ECS_VPC_ID is failing to become available | tee -a $LOGFILE
	exit 1
fi


#Put a tag on the VPC
echo put a tag on the VPC | tee -a $LOGFILE
echo aws ec2 create-tags --resources $ECS_VPC_ID --tags Key=Name,Value=$ECS_VPC_TAG_NAME | tee -a $LOGFILE
aws ec2 create-tags --resources $ECS_VPC_ID --tags Key=Name,Value=$ECS_VPC_TAG_NAME | tee -a $LOGFILE
RC=$?
echo return code $RC
#End create the VPC
#
#

#Create the Security Group
echo Create the Security Group | tee -a $LOGFILE
echo aws ec2 create-security-group --group-name $ECS_SECURITY_GROUP_NAME --description $ECS_SECURITY_GROUP_DESCRIPTION --vpc-id $ECS_VPC_ID | tee -a $LOGFILE
aws ec2 create-security-group --group-name $ECS_SECURITY_GROUP_NAME --description $ECS_SECURITY_GROUP_DESCRIPTION --vpc-id $ECS_VPC_ID | tee $TMPFILE
RC=$?
echo return code $RC
ECS_SG_ID=`grep GroupId $TMPFILE | awk -F\" '{print $4}'` 
RC=$?
echo return code $RC |  tee -a $LOGFILE
echo
echo put a tag on the Security Group | tee -a $LOGFILE
echo aws ec2 create-tags --resources $ECS_SG_ID --tags Key=Name,Value=$ECS_SG_TAG_NAME | tee -a $LOGFILE
aws ec2 create-tags --resources $ECS_SG_ID --tags Key=Name,Value=$ECS_SG_TAG_NAME | tee -a $LOGFILE
RC=$?
echo return code $RC
#
#

#Security group rules. Note that SSH is very open
echo Add rules to the security group
#SSH
echo aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 22 --cidr $ECS_SECURITY_GROUP_SSH_CIDR |  tee -a $LOGFILE
aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 22 --cidr $ECS_SECURITY_GROUP_SSH_CIDR |  tee -a $LOGFILE
RC=$?
echo return code $RC
#HTTP
echo aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 80 --cidr $ECS_SECURITY_GROUP_HTTP_CIDR |  tee -a $LOGFILE
aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 80 --cidr $ECS_SECURITY_GROUP_HTTP_CIDR |  tee -a $LOGFILE
RC=$?
echo return code $RC
#HTTPS
echo aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 443 --cidr $ECS_SECURITY_GROUP_HTTPS_CIDR |  tee -a $LOGFILE
aws ec2 authorize-security-group-ingress --group-id $ECS_SG_ID --protocol tcp --port 443 --cidr $ECS_SECURITY_GROUP_HTTPS_CIDR |  tee -a $LOGFILE
RC=$?
echo return code $RC
echo

#SUBNETS
#Create 2 subnets for availability
echo aws ec2 create-subnet --availability-zone $ECS_CLUSTER_AZS1 --vpc-id $ECS_VPC_ID --cidr-block $ECS_CLUSTER_AZS1_CIDR  |  tee $TMPFILE
aws ec2 create-subnet --availability-zone $ECS_CLUSTER_AZS1 --vpc-id $ECS_VPC_ID --cidr-block $ECS_CLUSTER_AZS1_CIDR  |  tee $TMPFILE
SUBNET_ID_1=`grep SubnetId $TMPFILE | awk -F\" '{print $4}'` 
cat $TMPFILE >> $LOGFILE
#Put a tag on the first subnet
echo aws ec2 create-tags --resources $SUBNET_ID_1 --tags Key=Name,Value=$SUBNET_ID_1_TAG | tee -a $LOGFILE
aws ec2 create-tags --resources $SUBNET_ID_1 --tags Key=Name,Value=$SUBNET_ID_1_TAG | tee -a $LOGFILE
RC=$?


echo aws ec2 create-subnet --availability-zone $ECS_CLUSTER_AZS2 --vpc-id $ECS_VPC_ID --cidr-block $ECS_CLUSTER_AZS2_CIDR  |  tee $TMPFILE
aws ec2 create-subnet --availability-zone $ECS_CLUSTER_AZS2 --vpc-id $ECS_VPC_ID --cidr-block $ECS_CLUSTER_AZS2_CIDR  |  tee $TMPFILE
SUBNET_ID_2=`grep SubnetId $TMPFILE | awk -F\" '{print $4}'` 
cat $TMPFILE >> $LOGFILE
#Put a tag on the second subnet
echo aws ec2 create-tags --resources $SUBNET_ID_2 --tags Key=Name,Value=$SUBNET_ID_2_TAG | tee -a $LOGFILE
aws ec2 create-tags --resources $SUBNET_ID_2 --tags Key=Name,Value=$SUBNET_ID_2_TAG | tee -a $LOGFILE
RC=$?

#Internet GW
echo aws ec2 create-internet-gateway | tee -a $LOGFILE
aws ec2 create-internet-gateway | tee $TMPFILE
IGW_ID=`grep InternetGatewayId $TMPFILE | awk -F\" '{print $4}'`
cat $TMPFILE >> $LOGFILE
#Put a tag in the IGW
echo aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$ECS_IGW_TAG | tee -a $LOGFILE
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$ECS_IGW_TAG | tee -a $LOGFILE
#Attach IGW to VPC
#aws ec2 attach-internet-gateway --vpc-id  $ECS_VPC_ID --internet-gateway-id $IGW_ID --region $ECS_REGION | tee -a $LOGFILE
aws ec2 attach-internet-gateway --vpc-id  $ECS_VPC_ID --internet-gateway-id $IGW_ID --region $ECS_REGION | tee -a $LOGFILE
#
#
#Route Table
echo aws ec2 create-route-table --vpc-id  $ECS_VPC_ID  |  tee $TMPFILE
aws ec2 create-route-table --vpc-id  $ECS_VPC_ID  |  tee $TMPFILE
ROUTE_TABLE_ID=`grep RouteTableId $TMPFILE | awk -F\" '{print $4}'`
cat $TMPFILE >> $LOGFILE
#Put a tag on the route table
echo aws ec2 create-tags --resources $ROUTE_TABLE_ID --tags Key=Name,Value=$ROUTE_TABLE_ID_TAG | tee -a $LOGFILE
aws ec2 create-tags --resources $ROUTE_TABLE_ID --tags Key=Name,Value=$ROUTE_TABLE_ID_TAG | tee -a $LOGFILE
#Create route
echo aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block $ROUTE_CIDR --gateway-id $IGW_ID | tee -a $LOGFILE
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block $ROUTE_CIDR --gateway-id $IGW_ID | tee -a $LOGFILE
#Associate route table
#SUBNET_ID_1
echo aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1  | tee -a $LOGFILE
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1  | tee -a $LOGFILE
#SUBNET_ID_2
echo aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2  | tee -a $LOGFILE
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2  | tee -a $LOGFILE

########################################### End of the AWS EC2 Commands for creation and setup of VPC

########################################### Start of the ECS-CLI Commands 
#Configure the profile
echo Configures your AWS ECS credentials in a named Amazon ECS profile, which is stored in the ~/.ecs/credentials file |  tee -a $LOGFILE
echo ecs-cli configure profile --profile-name $ECS_PROFILE_NAME --access-key $ECS_AWS_ACCESS_KEY_ID  --secret-key $ECS_AWS_SECRET_ACCESS_KEY |  tee -a $LOGFILE
ecs-cli configure profile --profile-name $ECS_PROFILE_NAME --access-key $ECS_AWS_ACCESS_KEY_ID  --secret-key $ECS_AWS_SECRET_ACCESS_KEY |  tee -a $LOGFILE
RC=$?
echo return code $RC |  tee -a $LOGFILE
echo

#Create the cluster config in ~/.ecs/config
echo Create the cluster config in ~/.ecs/config |  tee -a $LOGFILE
echo ecs-cli configure --cluster $ECS_CLUSTER --default-launch-type EC2 --region $ECS_REGION --config-name $ECS_CLUSTER_CONFIG_NAME |  tee -a $LOGFILE
ecs-cli configure --cluster $ECS_CLUSTER --default-launch-type EC2 --region $ECS_REGION --config-name $ECS_CLUSTER_CONFIG_NAME |  tee -a $LOGFILE
RC=$?
echo return code $RC |  tee -a $LOGFILE
echo

#Create and bring up the cluster
echo Create and bring up the cluster |  tee -a $LOGFILE
echo ecs-cli up --keypair $ECS_CLUSTER_KEYPAIR --capability-iam --size $ECS_CLUSTER_SIZE --instance-type $ECS_INSTANCE_TYPE --cluster-config $ECS_CLUSTER_CONFIG_NAME --security-group $ECS_SG_ID --subnets ${SUBNET_ID_1},${SUBNET_ID_2} --vpc $ECS_VPC_ID  |  tee -a $LOGFILE
ecs-cli up --keypair $ECS_CLUSTER_KEYPAIR --capability-iam --size $ECS_CLUSTER_SIZE --instance-type $ECS_INSTANCE_TYPE --cluster-config $ECS_CLUSTER_CONFIG_NAME --security-group $ECS_SG_ID --subnets ${SUBNET_ID_1},${SUBNET_ID_2} --vpc $ECS_VPC_ID |  tee -a $LOGFILE
RC=$?
echo return code $RC |  tee -a $LOGFILE
echo

########################################### End of the ECS-CLI Commands 
