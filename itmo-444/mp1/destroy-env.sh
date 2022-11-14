#/bin/bash


# Sample code to retrieve objects (file) names
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-objects-v2.html
aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key'
FILENAMESRAW=$(aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key')
FILENAMESFIN=$(aws s3api list-objects-v2 --bucket ${19} --query 'Contents[*].Key')

echo ${18}
echo "Deleting Bucket Raw Items"
for FILE in $FILENAMESRAW; do
    aws s3api delete-object --bucket ${18} --key $FILE
done

echo ${19}
echo "Deleting Bucket Fin Items"
for FILE in $FILENAMESFIN; do
    aws s3api delete-object --bucket ${19} --key $FILE
done
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-object.html


# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-bucket.html
#aws s3api delete-bucket --buket ${18}

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-buckets.html

echo "Deleting Buckets"
LISTOFBUCKETS=$(aws s3api list-buckets --query 'Buckets[*].Name')
for BUCK in $LISTOFBUCKETS; do
    aws s3api delete-bucket --bucket $BUCK
done
# convert string list of buckets to an array, iterate through it (for each loop)
ASG=$(aws autoscaling describe-auto-scaling-groups --output=text --query='AutoScalingGroups[*].AutoScalingGroupName')
LB=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn')
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn')
LS=$(aws elbv2 describe-listeners --load-balancer-arn $LB --output=text --query='Listeners[*].ListenerArn')
LCN=$(aws autoscaling describe-launch-configurations --output=text --query='LaunchConfigurations[*].LaunchConfigurationName')
IDS=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running,pending" --query "Reservations[*].Instances[*].InstanceId")
DBIDS=$(aws rds describe-db-instances --output=text --query="DBInstances[*].DBInstanceIdentifier")
echo "IDS: "
echo $IDS

aws autoscaling suspend-processes --auto-scaling-group-name $ASG
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $ASG --min-size 0 --max-size 0 --desired-capacity 0
aws autoscaling detach-instances --instance-ids $IDS --auto-scaling-group-name $ASG --should-decrement-desired-capacity

aws autoscaling detach-load-balancer-target-groups --auto-scaling-group-name $ASG --target-group-arns $TG
#iaws autoscaling detach-load-balancers --auto-scaling-group-name $ASG --load-balancer-names $LB
aws ec2 terminate-instances --instance-ids $IDS 
aws ec2 wait instance-terminated --instance-ids $IDS
echo "Terminated Instances"

aws elbv2 delete-listener --listener-arn $LS 
echo "Deleted Listener"

aws elbv2 delete-target-group --target-group-arn $TG
echo "Deleted Target Group"

aws elbv2 delete-load-balancer --load-balancer-arn $LB 
echo "Deleted Load Balancer"

aws elbv2 wait load-balancers-deleted --load-balancer-arns $LB

sleep 120

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG
echo "Deleted Auto Scaling Group"

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
