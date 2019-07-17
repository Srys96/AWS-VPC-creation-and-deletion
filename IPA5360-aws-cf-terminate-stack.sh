#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "usage: $0 <vpcid>"
    exit 64
fi

#for region in $(aws ec2 describe-regions --region us-east-1 | jq -r .Regions[].RegionName); do
region="us-east-1"
echo "Region ${region}"

# Get Default VPC
vpc=$(aws ec2 --region ${region} \
  describe-vpcs --filter Name=isDefault,Values=false \
  | jq -r .Vpcs[0].VpcId)
if [ "${vpc}" = "null" ]; then
  echo "No default vpc found"
  continue
fi
echo "Found default vpc ${vpc}"

# Get Internet Gateway
igw=$(aws ec2 --region ${region} \
  describe-internet-gateways --filter Name=attachment.vpc-id,Values=${vpc} \
  | jq -r .InternetGateways[0].InternetGatewayId)
if [ "${igw}" != "null" ]; then
  echo "Detaching and deleting internet gateway ${igw}"
  aws ec2 --region ${region} \
    detach-internet-gateway --internet-gateway-id ${igw} --vpc-id ${vpc}
  aws ec2 --region ${region} \
    delete-internet-gateway --internet-gateway-id ${igw}
fi

# Retrieving Route-Table-Id
echo "Retrieve Route Table ID"
routeid=$(aws ec2 describe-route-tables \
	--filters "Name=vpc-id,Values=$vpc" "Name=association.main, Values=false" \
	--query 'RouteTables[*].{RouteTableId:RouteTableId}' \
	--output text)

routeids=( $routeid )
routeid1=${routeids[0]}
routeid2=${routeids[1]}

echo "First Route-Table ID: '$routeid1'"
echo "Second Route-Table ID: '$routeid2'"

# Disassociation of Public Subnets with Route Table 1
echo "Subnet and Public Route Table Disassociation"
aws ec2 describe-route-tables \
	--query 'RouteTables[*].Associations[].{RouteTableAssociationId:RouteTableAssociationId}' \
	--route-table-id $routeid1 \
	--output text|while read var_assid1; do aws ec2 disassociate-route-table --association-id $var_assid1; done
echo "Completed"

echo "Subnet and Private Route Table Disassociation"
aws ec2 describe-route-tables \
	--query 'RouteTables[*].Associations[].{RouteTableAssociationId:RouteTableAssociationId}' \
	--route-table-id $routeid2 \
	--output text|while read var_assid2; do aws ec2 disassociate-route-table --association-id $var_assid2; done
echo "Completed"

  # get route table
  #routeid=$(aws ec2 --region ${region} \
   # describe-route-tables --filter Name=attachment.vpc-id,Values=${vpc} \
    #| jq -r .RouteTables[].RouteTableId)
 # if [ "${igw}" != "null" ]; then
  #  echo "Disassociating and deleting route table ${routeid}"
   ##  disassociate-route-table --route-table-id ${routeid} --vpc-id ${vpc}
    #aws ec2 --region ${region} \
    #  delete-route-table --route-table-id ${routeid}
  #fi

  #aws ec2 describe-route-tables --filter Name=vpc-id,Values=${vpc} --region ${region} | jq -r '.RouteTables[].RouteTableId' |


   # while read routeID; do
    #  echo "Deleting route table (${routeID})"
     #   aws ec2 delete-route --route-table-id ${routeID} --region ${region} &>/dev/null
      #  aws ec2 dissociate-route-table --route-table-id ${routeID} --region ${region} &>/dev/null
       # aws ec2 delete-route-table --route-table-id ${routeID} --region ${region} &>/dev/null
    #done

#for i in `aws ec2 describe-route-tables --filters Name=vpc-id,Values="${vpc}" | grep rtb- | sed -E 's/^.*(rtb-[a-z0-9]+).*$/\1/' | sort | uniq`; do aws ec2 delete-route-table --route-table-id $i; done

# Get Subnets
subnets=$(aws ec2 --region ${region} \
  describe-subnets --filters Name=vpc-id,Values=${vpc} \
  | jq -r .Subnets[].SubnetId)
if [ "${subnets}" != "null" ]; then
  for subnet in ${subnets}; do
    echo "Deleting subnet ${subnet}"
    aws ec2 --region ${region} \
      delete-subnet --subnet-id ${subnet}
  done
fi

# Retrieving Main Route Table
echo "Retrieving Route Table"
mainrouteid=$(aws ec2 describe-route-tables \
	--query "RouteTables[?VpcId=='$vpc']|[?Associations[?Main!=true]].RouteTableId" \
	--output text)

echo "id = $mainrouteid"

#Delete Route Table
echo "Deleting Route Table"
for i in $routeid
do
	if [[ $i != $mainrouteid ]]; then
		aws ec2 delete-route-table --route-table-id $i
		echo $i
	fi
done
echo "Route table deleted!"

# Delete route table (ignore message about being unable to delete default security group)
#echo "Deleting route table."
#for i in `aws ec2 describe-route-tables --filters Name=vpc-id,Values="${vpc}" | grep rtb- | sed -E 's/^.*(rtb-[a-z0-9]+).*$/\1/' | sort | uniq`; do aws ec2 delete-route-table --route-table-id $i; done


# Delete Default VPC
echo "Deleting vpc ${vpc}"
aws ec2 --region ${region} \
  delete-vpc --vpc-id ${vpc}

echo "Successfully Deleted VPC and all its Dependencies."