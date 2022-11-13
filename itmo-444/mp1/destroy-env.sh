#/bin/bash


# Sample code to retrieve objects (file) names
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-objects-v2.html
aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key'
FILENAMESRAW=$(aws s3api list-objects-v2 --bucket ${18} --query 'Contents[*].Key')
FILENAMESFIN=$(aws s3api list-objects-v2 --bucket ${19} --query 'Contents[*].Key')

for FILE in $FILENAMESRAW; do
    aws s3api delete-object --bucket ${18} --key $FILE
done

for FILE in $FILENAMESFIN; do
    aws s3api delete-object --bucket ${19} --key $FILE
done
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-object.html


# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/delete-bucket.html
aws s3api delete-bucket --buket ${18}

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-buckets.html
aws s3api list-buckets

LISTOFBUCKETS=$(aws s3api list-buckets --query 'Buckets[*].Name')
for BUCK in $LISTOFBUCKETS; do
    aws s3api delete-bucket --bucket $BUCK
done
# convert string list of buckets to an array, iterate through it (for each loop)
