# export
#!/usr/bin/env bash

mkdir -p ./data

TABLE_NAME="$1"

if [ $TABLE_NAME = "" ]; then
  echo "Missing table name."
else
  res="aws dynamodb scan --table-name $TABLE_NAME  --max-items 25 --output json --endpoint-url https://dynamodb.ap-southeast-1.amazonaws.com";
  index=1;
  nextToken=`jq -r '.NextToken' <<< $res`;
  while [[ "${nextToken}" != "" ]]
  do
    echo $nextToken;
    echo $res | jq '{"'$TABLE_NAME'": [.Items[] | {PutRequest: {Item: .}}]}' > ./data/$TABLE_NAME-$index.json;
    ((index+=1))
    res=`aws dynamodb scan --table-name $TABLE_NAME --max-items 25 --starting-token $nextToken --output json --endpoint-url https://dynamodb.ap-southeast-1.amazonaws.com`;
    nextToken=`jq -r '.NextToken' <<< $res`;
  done
fi
