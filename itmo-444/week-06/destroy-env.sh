#!/bin/bash

######################################################################
# Since all elements have been created no need to send any inputs 
# use the --query to get all of the needed IDs and reverse everything
# you did in the create-env.sh 
# you may need to use WAIT in some steps
######################################################################
LB=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn')
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn')
LS=$(aws elbv2 describe-listeners --load-balancer-arn $LB --output=text --query='Listeners[*].ListenerArn')

aws elbv2 delete-listener --listener-arn $LS

aws elbv2 delete-load-balancer --load-balancer-arn $LB

aws elbv2 delete-target-group --target-group-arn $TG 

IDS=$(aws ec2 describe-instances --output=table | grep InstanceId | awk {'print $4'})

echo $IDS

aws ec2 terminate-instances --instance-ids $IDS
