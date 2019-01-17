#!/bin/bash
# To Launch one Ubuntu Xenial EC2 instance
# Define several variables
DATE_ID=$(date +%s)
SG_NAME="ec2-sg-$DATE_ID"
KEY_NAME="ec2-key-$DATE_ID"
INSTANCE_TYPE="t2.micro"
SCRIPT="--user-data file://gitlabrunner.sh"
# Create a security group
echo -e "1. Create a security group"
SGID=$(aws ec2 create-security-group --group-name $SG_NAME \
--description "gitlab runner Security Group" \
--vpc-id $(aws ec2 describe-vpcs | jq -r .Vpcs[].VpcId) | jq -r .GroupId)
# Add an ingress rule for ssh management trafic
echo -e "2. Add an ingress rule for ssh management trafic"
aws ec2 authorize-security-group-ingress --group-name $SG_NAME \
--protocol tcp --port 22 --cidr 0.0.0.0/0
# Delete the old key anyway
echo -e "3. Delete the old SSH private key anyway"
rm -f ~/.ssh/$KEY_NAME.pem
# Create a new SSH private key
echo -e "4. Create a new SSH private key and restrict rights to only you"
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' \
--output text > ~/.ssh/$KEY_NAME.pem
# Restrict rights on the key
chmod 400 ~/.ssh/$KEY_NAME.pem
# Get an Ubuntu Xenial Image ID
echo -e "5. Get an Ubuntu Xenial Image ID"
IMAGE_ID=$(aws ec2 describe-images --owners 099720109477 \
--filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-????????' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId')
# Launch the EC2 instance
echo -e "6. Launch the EC2 instance with type, key name, security group and image id"
INSTANCE_ID=$(aws ec2 run-instances --instance-type $INSTANCE_TYPE --key-name $KEY_NAME \
--security-group-ids $SGID --image-id $IMAGE_ID $SCRIPT | jq -r '.Instances[] | .InstanceId')
# Get the instance ID
echo -e "7. Get the instance IP"
INSTANCE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r .Reservations[].Instances[].PublicIpAddress)
# Store the connexion informations into the ~/aws-ec2-instances.csv
echo "$INSTANCE_ID,~/.ssh/$KEY_NAME.pem,$INSTANCE_IP" >> ~/aws-ec2-instances.csv
# Final Message
echo -e "   To get an ssh terminal use this command:"
echo -e "   ssh -i ~/.ssh/$KEY_NAME.pem ubuntu@$INSTANCE_IP"
echo -e "   This information is stored in ~/aws-ec2-instances.csv"
