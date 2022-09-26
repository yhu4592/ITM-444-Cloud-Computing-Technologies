#!/bin/bash

aws ec2 run-instances --image-id $1 --instance-type $2 --key-name $3 --security-group-ids $4 --user-data file://install-env.sh