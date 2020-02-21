if [ "$1" = "create" ]
then
    echo "create"
    aws cloudformation create-stack \
    --stack-name $2 \
    --template-body file://$3 \
    --parameters file://$4 \
    --region=us-west-2 \
    --capabilities CAPABILITY_IAM
fi

if [ "$1" = "update" ]
then
    echo "Updating"
    aws cloudformation update-stack \
    --stack-name $2 \
    --template-body file://$3 \
    --parameters file://$4 \
    --region=us-west-2 \
    --capabilities CAPABILITY_IAM
fi


if [ "$1" = "delete" ]
then
    echo "delete"
    aws cloudformation delete-stack \
    --stack-name $2 \
    --region=us-west-2
fi

if [ "$1" = "validate" ]
then
    aws cloudformation validate-template \
    --template-body file://$2 \
    --region=us-west-2
fi
