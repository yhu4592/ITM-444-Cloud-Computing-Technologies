#!/bin/bash

#########################################
# Format of arguments.txt
# $1 image-id
# $2 instance-type
# $3 key-name
# $4 security-group-ids
# $5 count (3)
# $6 availability-zone
# $7 elb name
# $8 target group name
######################################################################

# Tasks to accomplish

# Get Subnet 1 ID
# Get Subnet 2 ID
# Get VPCID
VPCID=$(aws ec2 describe-vpcs --output=text --query='Vpcs[*].VpcId' --no-paginate)
SUBNETIDS1=$(aws ec2 describe-subnets --output=text --query 'Subnets[0].SubnetId' --no-cli-pager)
SUBNETIDS2=$(aws ec2 describe-subnets --output=text --query 'Subnets[1].SubnetId' --no-cli-pager)

# Launch 3 EC2 instnaces 
aws ec2 run-instances --image-id $1 --instance-type $2 --key-name $3 --security-group-ids $4 --count $5 --user-data file://install-env.sh --no-cli-pager

IDS=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=pending --query "Reservations[*].Instances[*].InstanceId")

# Run EC2 wait until EC2 instances are in the running state
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/wait/index.html
aws ec2 wait instance-running \
	    --instance-ids $IDS
	    
IDS=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId")

# Create AWS elbv2 target group (use default values for health-checks)
aws elbv2 create-target-group \
	    --name $8 \
	        --protocol HTTP \
		    --port 80 \
		        --target-type instance \
			    --vpc-id $VPCID \
			       --no-cli-pager
			    
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn' --no-cli-pager)
for ID in $IDS; do
	                aws elbv2 register-targets --target-group-arn $TG  --targets Id=$ID
			        done

aws elbv2 wait target-in-service --target-group-arn $TG --no-cli-pager

# create AWS elbv2 load-balancer
aws elbv2 create-load-balancer \
	    --name $7 \
	        --subnets $SUBNETIDS1 $SUBNETIDS2 \
		      --no-cli-pager \
                        --security-groups $4

# AWS elbv2 wait for load-balancer available
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/wait/load-balancer-available.html
aws elbv2 wait load-balancer-available \
	    --names $7 \
	       --no-cli-pager

LB=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn' --no-cli-pager)


# create AWS elbv2 listener for HTTP on port 80
#https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/create-listener.html
aws elbv2 create-listener \
	    --load-balancer-arn $LB \
	        --protocol HTTP \
		    --port 80 \
		        --default-actions Type=forward,TargetGroupArn=$TG \
			   --no-cli-pager


# Retreive ELBv2 URL via aws elbv2 describe-load-balancers --query and print it to the screen
URL=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].DNSName' --no-cli-pager)
echo $URL
