# JanTechTestApp

[![Release]][release]

[release]:https://github.com/jnorback/JanTechTestApp/releases/latest



## Overview

The aim of the current version of the pre-production application is to span up:
### A new VPC with:
* A Security Group with HTTP, HTTPS and SSH access for all (SHH to be restricted later)
* 2 subnets for availability in different availability zones
* An Internet GW attached to the VPC
* A route table that routes to the IGW for both subnets
### An ECS EC2 cluster within the VPC with:
* 2 EC2 of type t3.small
### A simple Docker application:
* See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-ec2.html

## Pre Requisites

* A Linux AMI instance in AWS that used to spanup and control the environment remotely through aws ec2 CLI and ecs-cli
* An AWS account that have at least one available slot for a new VPC (the default is 5 max).
* An AWS user that is allowed to access, crete, delete and manage VPC resources. (To be specified). An access key needs to be created for this user and saved.
* Use the access keys to configure aws as a user on the Linux instance (matt in this example, with Sydney as the region):
* matt@host $aws configure
* AWS Access Key ID: SECRET_ID
* AWS Secret Access Key: SECRET_KEY 
* Default region name: ap-southeast-2
* Default output format: json





