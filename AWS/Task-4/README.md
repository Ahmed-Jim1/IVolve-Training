# Task 4: SDK and CLI Interactions

## Objective
Use the AWS CLI to create an S3 bucket, configure permissions, upload/download files to/from the bucket, and enable versioning and logging. Ensure permissions are managed using a bucket policy to avoid ACL-related errors.

## Prerequisites

- AWS CLI installed and configured:
  ```bash
  aws configure
  ```

put your configration 

IAM user with the necessary permissions:
- s3:CreateBucket
- s3:PutBucketPolicy
- s3:PutBucketVersioning
- s3:PutBucketLogging
- s3:PutObject
- s3:GetObject

### 1. Create an S3 Bucket and Set Block Public ACLs to False

```bash
aws s3api create-bucket --bucket ams-s3-bucket-ivolve --region us-east-1
aws s3api put-public-access-block --bucket ams-s3-bucket-ivolve --public-access-block-configuration BlockPublicAcls=false
```

![s3](./images/s3.png)

### 2. Apply a Bucket Policy

```bash
vim bucket-policy.json 
```
put this policy 
```json
{
    "Version": "2012-10-17",
    "Statement": 
        
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::ams-s3-bucket-ivolve/*"
        ,
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::ams-s3-bucket-ivolve/*"
        }
    
}

```
apply the policy 

```bash
 aws s3api put-bucket-policy --bucket ams-s3-bucket-ivolve --policy file://bucket-policy.json
```
![policy](./images/policy.png)

### 3. Enable Versioning
Enable versioning on the bucket:

```bash
aws s3api put-bucket-versioning --bucket ams-s3-bucket-ivolve --versioning-configuration Status=Enabled

```
### 4. Enable Logging
Enable logging for the original bucket:

```bash
 aws s3api put-bucket-logging --bucket ams-s3-bucket-ivolve --bucket-logging-status '{
    "LoggingEnabled": {
        "TargetBucket": "ams-s3-bucket-ivolve",
        "TargetPrefix": "logs/"
    }
}'
```
### 5. Upload and Download Files
Upload a File:
```bash
aws s3 cp bucket-policy.json s3://ams-s3-bucket-ivolve/bucket-policy.json
```
Download a File: 
```bash
aws s3 cp s3://ams-s3-bucket-ivolve/bucket-policy.json bucket-policy.json
```

### 6. List Files in the Bucket
```bash
aws s3 ls s3://ams-s3-bucket-ivolve
```
![list](./images/list.png)