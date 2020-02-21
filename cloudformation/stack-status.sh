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

    SERVICE_ROLE=$(aws iam get-role --role-name "$IAM_EKS_ROLE" --query Role.Arn --output text)
    SECURITY_GROUP=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='SecurityGroups'].OutputValue" --output text)
    SUBNET_IDS=$( aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='SubnetIds'].OutputValue" --output text)

    echo "Role ARN: $SERVICE_ROLE"
    echo "Security Group IDs: $SECURITY_GROUP"
    echo "Subnet IDs: $SUBNET_IDS"


    aws eks create-cluster --name "$EKS_CLUSTER_NAME" --role-arn "$SERVICE_ROLE" --resources-vpc-config subnetIds="$SUBNET_IDS",securityGroupIds="$SECURITY_GROUP"
    until [[ `aws eks describe-cluster --name "${EKS_CLUSTER_NAME}" --query cluster.status --output text` == "ACTIVE" ]];
    do  echo "The EKS cluster is NOT in a state of ACTIVE at `date`";
      sleep 30;
    done && echo "The EKS cluster has been completed at `date`"

    # Add the kubectl config
    aws eks update-kubeconfig --name $EKS_CLUSTER_NAME
    echo "Clusters available in your kubectl configuration"
    kubectl config get-contexts | grep $EKS_CLUSTER_NAME
    echo "Set the cluster in kubectl (set the correct name), example: 'kubectl config use-context arn:aws:eks:${REGION}:000000000000:cluster/${EKS_CLUSTER_NAME}'"
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

    aws eks delete-cluster --name $STACK_NAME
fi

if [ "$1" = "validate" ]
then
    TEMPLATE=$2
    REGION=us-west-2

    aws cloudformation validate-template \
    --template-body file://$TEMPLATE \
    --region=$REGION
fi
