#!/bin/bash

IDS=$(aws ec2 describe-instances --output=table | grep InstanceId | awk {'print $4'})

echo $IDS

aws ec2 terminate-instances --instance-ids $IDS