#!/bin/bash

AWS_SG_NAME="sgfrancois9"
AWS_KEY_NAME="francois9-key"
AWS_SGID=$(aws ec2 create-security-group --group-name $AWS_SG_NAME --description "gitlab runner Security Group" --vpc-id $(aws ec2 describe-vpcs | jq -r .Vpcs[].VpcId) | jq -r .GroupId)
aws ec2 authorize-security-group-ingress --group-name $AWS_SG_NAME --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 create-key-pair --key-name $AWS_KEY_NAME --query 'KeyMaterial' --output text > ~/.ssh/$AWS_KEY_NAME.pem
AWS_INSTANCE_ID=$(aws ec2 run-instances --instance-type t2.micro --key-name $AWS_KEY_NAME --security-group-ids $AWS_SGID --image-id $(aws ec2 describe-images --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-????????' 'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId') | jq -r '.Instances[] | .InstanceId')
aws ec2 describe-instances --instance-ids $AWS_INSTANCE_ID | jq -r .Reservations[].Instances[].PublicIpAddress
chmod 400 ~/.ssh/$AWS_KEY_NAME.pem
ssh -i ~/.ssh/$AWS_KEY_NAME.pem ubuntu@$(aws ec2 describe-instances --instance-ids $AWS_INSTANCE_ID | jq -r .Reservations[].Instances[].PublicIpAddress)
