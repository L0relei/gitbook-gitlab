#!/bin/bash
# To Launch one EC2 instance
# Define several variables
DATE_ID=$(date +%s)
SG_NAME="ec2-sg-$DATE_ID"
KEY_NAME="ec2-key-$DATE_ID"
INSTANCE_TYPE="t2.micro"
# Create a security group
echo -e "Create a security group"
SGID=$(aws ec2 create-security-group --group-name $SG_NAME \
--description "gitlab runner Security Group" \
--vpc-id $(aws ec2 describe-vpcs | jq -r .Vpcs[].VpcId) | jq -r .GroupId)
# Add an ingress rule for ssh management trafic
echo -e "Add an ingress rule for ssh management trafic"
aws ec2 authorize-security-group-ingress --group-name $SG_NAME \
--protocol tcp --port 22 --cidr 0.0.0.0/0
# Delete the old key anyway
echo -e "Delete the old key anyway"
rm -f ~/.ssh/$KEY_NAME.pem
# Create a new key
echo -e "Create a new key"
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' \
--output text > ~/.ssh/$KEY_NAME.pem
# Restrict rights on the key
chmod 400 ~/.ssh/$KEY_NAME.pem
# Get an Ubuntu Xenial Image ID
echo -e "Get an Ubuntu Xenial Image ID"
IMAGE_ID=$(aws ec2 describe-images --owners 099720109477 \
--filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-????????' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId')
# Launch the EC2 instance
echo -e "Launch the EC2 instance with type, keyname, security group and image id"
INSTANCE_ID=$(aws ec2 run-instances --instance-type $INSTANCE_TYPE --key-name $KEY_NAME \
--security-group-ids $SGID --image-id $IMAGE_ID | jq -r '.Instances[] | .InstanceId')
# Get the instance ID
echo -e "Get the instance ID"
INSTANCE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r .Reservations[].Instances[].PublicIpAddress)
# Store the connexion informations into the ~/aws-ec2-instances.csv
echo '"$INSTANCE_ID","~/.ssh/$KEY_NAME.pem","$INSTANCE_IP"' >> ~/aws-ec2-instances.csv
# Final Message
echo -e "To connect to your instance with ssh use this command:\nssh -i ~/.ssh/$KEY_NAME.pem ubuntu@$INSTANCE_IP"
echo -e "This information is stored in ~/aws-ec2-instances.csv"
