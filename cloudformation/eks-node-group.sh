if [ "$1" = "create" ]
then
    STACK_NAME=$2
    TEMPLATE=$3
    PARAMS=$4
    REGION=us-west-2
    IAM_EKS_ROLE=EKSServiceRole
    EKS_CLUSTER_NAME=capstone

    echo "create"
    aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE \
    --parameters file://$PARAMS \
    --region=$REGION \
    --capabilities CAPABILITY_IAM

    until [[ `aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].[StackStatus]" --output text` == "CREATE_COMPLETE" ]];
    do  echo "The stack is NOT in a state of CREATE_COMPLETE at `date`";
      sleep 30;
    done && echo "The Stack is built at `date`"
    curl -O https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/aws-auth-cm.yaml
fi

if [ "$1" = "update" ]
then
    STACK_NAME=$2
    TEMPLATE=$3
    PARAMS=$4
    REGION=us-west-2
    IAM_EKS_ROLE=EKSServiceRole
    EKS_CLUSTER_NAME=capstone

    echo "Updating"
    aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE \
    --parameters file://$PARAMS \
    --region=$REGION \
    --capabilities CAPABILITY_IAM
fi


if [ "$1" = "delete" ]
then
    STACK_NAME=$2
    REGION=us-west-2

    echo "delete"
    aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region=$REGION
fi

if [ "$1" = "validate" ]
then
    TEMPLATE=$2
    REGION=us-west-2

    aws cloudformation validate-template \
    --template-body file://$TEMPLATE \
    --region=$REGION
fi
