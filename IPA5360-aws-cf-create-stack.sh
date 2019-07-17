#!/bin/bash
#********************************************
# AWS VPC Creation Shell Script
#********************************************
#
# SYNOPSIS
# Automates the creation of a custom IPv4 VPC, having both public and private subnets
#
# DESCRIPTION
# This shell script leverages the AWS CLI to automatically create a custom VPC
#
# CONSTANTS
#
aws_region="us-east-1"
#vpc_name="STACK_NAME-IPA5360-vpc"
vpc_cidr="10.0.0.0/16"
#subnet_public_cidr1="10.0.1.0/24"
#subnet_public_cidr2="10.0.2.0/24"
#subnet_public_cidr3="10.0.3.0/24"
#subnet_private_cidr1="10.0.4.0/24"
#subnet_private_cidr2="10.0.5.0/24"
#subnet_private_cidr3="10.0.6.0/24"
subnet_public_region1="us-east-1a"
subnet_private_region1="us-east-1a"
subnet_public_region2="us-east-1b"
subnet_private_region2="us-east-1b"
subnet_public_region3="us-east-1c"
subnet_private_region3="us-east-1c"
subnet_public_name1="ipa-public-subnet-1"
subnet_public_name2="ipa-public-subnet-2"
subnet_public_name3="ipa-public-subnet-3"
subnet_private_name1="ipa-private-subnet-1"
subnet_private_name2="ipa-private-subnet-2"
subnet_private_name3="ipa-private-subnet-3"
internet_gateway_name="STACK_NAME-IPA5360-InternetGateway"
public_route_table_name="STACK_NAME-IPA5360-public-route-table"
private_route_table_name="STACK_NAME-IPA5360-private-route-table"

# Creating VPC
echo "Creating VPC in preferred region..."
echo "Enter VPC Name: "
read vpc_name
vpc_id=$(aws ec2 create-vpc \
  --cidr-block ${vpc_cidr} \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region ${aws_region})
echo "VPC ID '$vpc_id' created in '$aws_region' region."

# Adding name tag to VPC
aws ec2 create-tags \
  --resources ${vpc_id} \
  --tags "Key=Name,Value=$vpc_name" \
  --region ${aws_region}
echo "VPC ID '$vpc_id' named as '$vpc_name'."

# Creating Public Subnet 1
echo "Creating public subnet 1..."
echo "Enter Public Subnet 1: "
read subnet_public_cidr1
subnet_public_id1=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_public_cidr1} \
  --availability-zone ${subnet_public_region1} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_public_id1' created in '$subnet_public_region1' availability zone."

# Adding name tag to Public Subnet 1
aws ec2 create-tags \
  --resources ${subnet_public_id1} \
  --tags "Key=Name,Value=$subnet_public_name1" \
  --region ${aws_region}
echo "Subnet ID '$subnet_public_id1' named as '$subnet_public_name1'."

# Creating Public Subnet 2
echo "Creating public subnet 2..."
echo "Enter Public Subnet 2: "
read subnet_public_cidr2
subnet_public_id2=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_public_cidr2} \
  --availability-zone ${subnet_public_region2} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_public_id2' created in '$subnet_public_region2' availability zone."

# Adding name tag to Public Subnet 2
aws ec2 create-tags \
  --resources ${subnet_public_id2} \
  --tags "Key=Name,Value=$subnet_public_name2" \
  --region ${aws_region}
echo "Subnet ID '$subnet_public_id2' named as '$subnet_public_name2'."

# Creating Public Subnet 3
echo "Enter Public Subnet 3: "
read subnet_public_cidr3
echo "Creating public subnet 3..."
subnet_public_id3=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_public_cidr3} \
  --availability-zone ${subnet_public_region3} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_public_id3' created in '$subnet_public_region3' availability zone."

# Adding name tag to Public Subnet 3
aws ec2 create-tags \
  --resources ${subnet_public_id3} \
  --tags "Key=Name,Value=$subnet_public_name3" \
  --region ${aws_region}
echo "Subnet ID '$subnet_public_id3' named as '$subnet_public_name3'."

# Creating Private Subnet 1
echo "Creating private subnet 1..."
echo "Enter Private Subnet 1: "
read subnet_private_cidr1
subnet_private_id1=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_private_cidr1} \
  --availability-zone ${subnet_private_region1} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_private_id1' created in '$subnet_private_region1' availability zone."

# Adding name tag to Private Subnet 1
aws ec2 create-tags \
  --resources ${subnet_private_id1} \
  --tags "Key=Name,Value=$subnet_private_name1" \
  --region ${aws_region}
echo "Subnet ID '$subnet_private_id1' named as '$subnet_private_name1'."

# Creating Private Subnet 2
echo "Creating private subnet 2..."
echo "Enter Private Subnet 2: "
read subnet_private_cidr2
subnet_private_id2=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_private_cidr2} \
  --availability-zone ${subnet_private_region2} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_private_id2' created in '$subnet_private_region2' availability zone."

# Adding name tag to Private Subnet 2
aws ec2 create-tags \
  --resources ${subnet_private_id2} \
  --tags "Key=Name,Value=$subnet_private_name2" \
  --region ${aws_region}
echo "Subnet ID '$subnet_private_id2' named as '$subnet_private_name2'."

# Creating Private Subnet 3
echo "Creating private subnet 3..."
echo "Enter Private Subnet 3: "
read subnet_private_cidr3
subnet_private_id3=$(aws ec2 create-subnet \
  --vpc-id ${vpc_id} \
  --cidr-block ${subnet_private_cidr3} \
  --availability-zone ${subnet_private_region3} \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region ${aws_region})
echo "Subnet ID '$subnet_private_id3' created in '$subnet_private_region3' availability zone."

# Adding name tag to Private Subnet 3
aws ec2 create-tags \
  --resources ${subnet_private_id3} \
  --tags "Key=Name,Value=$subnet_private_name3" \
  --region ${aws_region}
echo "Subnet ID '$subnet_private_id3' named as '$subnet_private_name3'."

# Creating Internet Gateway
echo "Creating internet gateway..."
igw_id=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region ${aws_region})
echo "Internet gateway ID '$igw_id' created."

# Adding name tag to Internet Gateway
aws ec2 create-tags \
  --resources ${igw_id} \
  --tags "Key=Name,Value=$internet_gateway_name" \
  --region ${aws_region}
echo "Internet gateway ID '$igw_id' named as '$internet_gateway_name'."

# Attaching internet gateway to the VPC
aws ec2 attach-internet-gateway \
  --vpc-id ${vpc_id} \
  --internet-gateway-id ${igw_id} \
  --region ${aws_region}
echo "Internet gateway ID '$igw_id' attached to VPC ID '$vpc_id'."

# Creating Public Route Table
echo "Creating route table..."
route_table_id_public=$(aws ec2 create-route-table \
  --vpc-id ${vpc_id} \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region ${aws_region})
echo "Route table ID '$route_table_id_public' created"

# Adding name tag to Public Route Table
aws ec2 create-tags \
  --resources ${route_table_id_public} \
  --tags "Key=Name,Value=$public_route_table_name" \
  --region ${aws_region}
echo "Public route table '$route_table_id_public' named as '$public_route_table_name'."

# Creating Private Route Table
echo "Creating route table..."
route_table_id_private=$(aws ec2 create-route-table \
  --vpc-id ${vpc_id} \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region ${aws_region})
echo "Route table ID '$route_table_id_private' created"

# Adding name tag to Private Route Table
aws ec2 create-tags \
  --resources ${route_table_id_private} \
  --tags "Key=Name,Value=$private_route_table_name" \
  --region ${aws_region}
echo "Private route table '$route_table_id_private' named as '$private_route_table_name'."

# Creating Public Route to Internet Gateway
RESULT=$(aws ec2 create-route \
  --route-table-id ${route_table_id_public} \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id ${igw_id} \
  --region ${aws_region})
echo "Route to '0.0.0.0/0' via internet gateway ID '$igw_id' added to route table ID '$route_table_id_public'."

# Creating Private Route to Internet Gateway
#RESULT=$(aws ec2 create-route \
 # --route-table-id ${route_table_id_private} \
  #--destination-cidr-block 0.0.0.0/0 \
  #--gateway-id ${igw_id} \
  #--region ${aws_region})
#echo "Route to '0.0.0.0/0' via internet gateway ID '$igw_id' added to route table ID '$route_table_id_private'."

# Associate Public Subnet 1 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_public_id1} \
  --route-table-id ${route_table_id_public} \
  --region ${aws_region})
echo "Public subnet ID '$subnet_public_id1' associated with route table ID '$route_table_id_public'."

# Associate Public Subnet 2 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_public_id2} \
  --route-table-id ${route_table_id_public} \
  --region ${aws_region})
echo "Public subnet ID '$subnet_public_id2' associated with route table ID '$route_table_id_public'."

# Associate Public Subnet 3 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_public_id3} \
  --route-table-id ${route_table_id_public} \
  --region ${aws_region})
echo "Public subnet ID '$subnet_public_id3' associated with route table ID '$route_table_id_public'."

# Associate Private Subnet 1 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_private_id1} \
  --route-table-id ${route_table_id_private} \
  --region ${aws_region})
echo "Private subnet ID '$subnet_private_id1' associated with route table ID '$route_table_id_private'."

# Associate Private Subnet 2 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_private_id2} \
  --route-table-id ${route_table_id_private} \
  --region ${aws_region})
echo "Private subnet ID '$subnet_private_id2' associated with route table ID '$route_table_id_private'."

# Associate Private Subnet 3 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id ${subnet_private_id3} \
  --route-table-id ${route_table_id_private} \
  --region ${aws_region})
echo "Private subnet ID '$subnet_private_id3' associated with route table ID '$route_table_id_private'."

echo "Successfully created VPC and all its Dependencies."
