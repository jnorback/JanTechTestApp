# JanTechTestApp
<!-- root/readme.md-->
[![Release]][release]

[release]:https://github.com/jnorback/JanTechTestApp/releases/latest

## Overview

The aim of the current version of the pre-production application is to, through manually interaction, first span up:
#### A new VPC with:
* A Security Group with HTTP, HTTPS and SSH access for all (SHH to be restricted later)
* 2 subnets for availability in different availability zones
* An Internet GW attached to the VPC
* A route table that routes to the IGW for both subnets
#### An ECS EC2 cluster within the VPC with:
* 2 EC2 of type t3.small

With the ECS cluster in place it is time to manually get a simple test docker application running as follows:
#### A simple Docker application:
* See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-ec2.html

## Pre Requisites

#### An AWS user account for CLI
* An AWS account that have at least one available slot for a new VPC (the default is 5 max).
* An AWS user that is allowed to access, crete, delete and manage VPC resources. (To be specified). An access key needs to be created for this user and saved.
* Use the access keys to configure aws as a user on the Linux instance (matt in this example, with Sydney as the region):
* matt@host $aws configure
* AWS Access Key ID: SECRET_ID
* AWS Secret Access Key: SECRET_KEY 
* Default region name: ap-southeast-2
* Default output format: json

#### An AWS user account for the ECS CLI
* An AWS user that is allowed to access, crete, delete and manage VPC resources. (To be specified). An access key needs to be created for this user and saved.

#### A Linux Development system
Example:

* A Linux AMI instance in AWS that used to spanup and control the environment remotely through aws ec2 CLI and ecs-cli
* Ensure that the AWS CLI is installed (default on the AMI Instance)
* Ensure that the AWS ESC-CLI is installed






