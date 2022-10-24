#!/bin/bash

######################################################################
# Since all elements have been created no need to send any inputs 
# use the --query to get all of the needed IDs and reverse everything
# you did in the create-env.sh 
# you may need to use WAIT in some steps
######################################################################
ASG=$(aws autoscaling describe-auto-scaling-groups --output=text --query='AutoScalingGroups[*].AutoScalingGroupName')
LB=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn')
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn')
LS=$(aws elbv2 describe-listeners --load-balancer-arn $LB --output=text --query='Listeners[*].ListenerArn')
LCN=$(aws autoscaling describe-launch-configurations --output=text --query='LaunchConfigurations[*].LaunchConfigurationName')

echo "Delete Auto Saling Group"
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG --force-delete

echo "Delete Listener"
aws elbv2 delete-listener --listener-arn $LS

echo "Delete Load Balancer"
aws elbv2 delete-load-balancer --load-balancer-arn $LB

echo "Delete Target Group"
aws elbv2 delete-target-group --target-group-arn $TG 

echo "Delete Launch Configuration"
aws autoscaling delete-launch-configuration --launch-configuration-name $LCN


