# JanTechTestApp

[![Release]][release]

[release]:https://github.com/jnorback/JanTechTestApp/releases/latest



## Overview

The aim of the current version of the pre-production application is to span up:
### A new VPC with:
* A Security Group with HTTP, HTTPS and SSH access for all (SHH to be restricted later)
* 2 subnets for availability in different availability zones
* An Internet GW attached to the VPC
* A route table with that routes to the IGW for both subnets
### An ECS EC2 cluster within the VPC with:
* 2 EC2 of type t3.small
### A simple Docker application

More details about the application can be found in the [document folder](doc/readme.md)

## Pre Requisites

An AWS account that have at least one available slot for a new VPC (the default is 5 max).
The code is 



