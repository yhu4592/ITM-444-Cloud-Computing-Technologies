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
SUBNETIDS1=$(aws ec2 describe-subnets --output=text --query 'Subnets[0].SubnetId' --no-paginate)
SUBNETIDS2=$(aws ec2 describe-subnets --output=text --query 'Subnets[1].SubnetId' --no-paginate)
# Launch 3 EC2 instnaces 
aws ec2 run-instances --image-id $1 --instance-type $2 --key-name $3 --security-group-ids $4 --count $5 --user-data file://install-env.sh --no-paginate

# Run EC2 wait until EC2 instances are in the running state
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/wait/index.html

# Create AWS elbv2 target group (use default values for health-checks)
aws elbv2 create-target-group \
	    --name $8 \
	        --protocol HTTP \
		    --port 80 \
		        --target-type instance \
			    --vpc-id $VPCID \
			       --no-paginate
			    
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn' --no-paginate )



# create AWS elbv2 load-balancer
aws elbv2 create-load-balancer \
	    --name $7 \
	        --subnets $SUBNETIDS1 $SUBNETIDS2 \
		   --no-paginate


# AWS elbv2 wait for load-balancer available
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/wait/load-balancer-available.html
aws elbv2 wait load-balancer-available \
	    --names $7 \
	       --no-paginate

LB=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn' --no-paginate)

# create AWS elbv2 listener for HTTP on port 80
#https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/create-listener.html
aws elbv2 create-listener \
	    --load-balancer-arn $LB \
	        --protocol HTTP \
		    --port 80 \
		        --default-actions Type=forward,TargetGroupArn=$TG \
			   --no-paginate

# Retreive ELBv2 URL via aws elbv2 describe-load-balancers --query and print it to the screen
URL=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].DNSName' --no-paginate)
echo $URL
