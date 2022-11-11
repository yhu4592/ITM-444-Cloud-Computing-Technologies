#/bin/bash


# Sample code to retrieve objects (file) names
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-objects-v2.html
aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key'
FILENAME=$(aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key')

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-object.html
aws s3api delete-object --bucket ${18} --key $FILENAME

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-bucket.html
aws s3api delete-bucket --buket ${18}

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-buckets.html
aws s3api list-buckets

LISTOFBUCKETS=$(aws s3api list-buckets --query 'Buckets[*].Name')

# convert string list of buckets to an array, iterate through it (for each loop)
