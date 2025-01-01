#!/usr/bin/env bash

INSTANCE_ID=$(
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Nat_instance_Bastion_host" \
  --query 'Reservations[].Instances[].[InstanceId]' \
  --output text )

echo $INSTANCE_ID

ENDPOINT_DB=$(aws rds describe-db-instances | jq -r '.DBInstances[].Endpoint.Address')

echo $ENDPOINT_DB

echo ..................
echo "Starting SSM session manager for connecting to Database"
echo ..................

aws ssm start-session --target ${INSTANCE_ID} \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"portNumber\":[\"3306\"],\"localPortNumber\":[\"8081\"],\"host\":[\"$ENDPOINT_DB\"]}"


echo $ENDPOINT_DB