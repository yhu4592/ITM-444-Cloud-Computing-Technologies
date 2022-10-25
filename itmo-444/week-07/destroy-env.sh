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
IDS=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId")
DBIDS=$(aws rds describe-db-instances --output=text --query="DBInstances[*].DBInstanceIdentifier")

aws autoscaling suspend-processes --auto-scaling-group-name $ASG

#aws autoscaling detach-instances --instance-ids $IDS --auto-scaling-group-name $ASG --no-should-decrement-desired-capacity --no-cli-pager


aws ec2 terminate-instances --instance-ids $IDS 
aws ec2 wait instance-terminated --instance-ids $IDS
echo "Terminated Instances"

#aws autoscaling suspend-processes --auto-scaling-group-name $ASG

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG 
echo "Deleted Auto Scaling Group"

aws elbv2 delete-listener --listener-arn $LS 
echo "Deleted Listener"

aws elbv2 delete-load-balancer --load-balancer-arn $LB 
echo "Deleted Load Balancer"

aws elbv2 delete-target-group --target-group-arn $TG 
echo "Deleted Target Group"

aws autoscaling delete-launch-configuration --launch-configuration-name $LCN
echo "Deleted Launch Configuration"

for DBID in $DBIDS; do
	
	aws rds delete-db-instance --db-instance-identifier $DBID --skip-final-snapshot --no-cli-pager
done
echo "Deleting DB Instances"

for DBID in $DBIDS; do
	aws rds wait db-instance-deleted --db-instance-identifier $DBID --no-cli-pager
done
echo "DB Instances Deleted"
