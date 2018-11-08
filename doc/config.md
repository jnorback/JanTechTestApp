# JanTechTestApp - Configuration Embryo to be completely changed
<!-- doc/config.md-->

This doc outlines how to configure the application using the config file. The main way to configure the application is through the configuration files.

## Configuration file

#####Secret Key file

The application is configured using two files with one stored in the root directory of the application and the second one must be created in a more secured location as it includes the keys for the IAM user used for the ECS. 

There is an example file, `root/example.tectest_env_extra.env` that could be copied to a secure location and adjusted to have the correct keys for the following variables:

* `ECS_AWS_ACCESS_KEY_ID`
* `ECS_AWS_SECRET_ACCESS_KEY`

#####Environment file for ECS spanup

The following needs to point to the special location for the secret key file used for the ESC-CLI client setup:

* `SECRET_KEY_FILE=~/.tectest_env_extra.env`


#####ECS VPC

* `VPC_CIDR_BLOCK="10.0.0.0/16"`
* `ECS_VPC_TAG_NAME=ECS_VIBRATO_TEST` Note that this is just a tag. You might like to change to fit your environment.

#####SECURITY_GROUP
##### Security group ports are defined in the script
* `ECS_SECURITY_GROUP_NAME=TechTestSG`
* `ECS_SECURITY_GROUP_DESCRIPTION=vibrato-test-security-group`
* `ECS_SG_TAG_NAME=ECS_SG` Note that this is just a tag. You might like to change to fit your environment.
#####Security Group CIDRs
#####Note: SSH is very open must be restricted in prod, bastion host?
* `ECS_SECURITY_GROUP_SSH_CIDR="0.0.0.0/0"`
* `ECS_SECURITY_GROUP_HTTP_CIDR="0.0.0.0/0"`
* `ECS_SECURITY_GROUP_HTTPS_CIDR="0.0.0.0/0"`

#####ROUTE Table
* `ROUTE_TABLE_ID_TAG=ECS_ROUTE_TABLE`
* `ROUTE_CIDR="0.0.0.0/0"`


#####PROFILE
* `ECS_PROFILE_NAME=VibratoTechTestAppCLI`


#####CLUSTER
* `ECS_CLUSTER=jan-vibrato-test`
* `ECS_REGION=ap-southeast-2`
* `ECS_CLUSTER_CONFIG_NAME=jan-vibrato-test-cfg`
* `ECS_CLUSTER_KEYPAIR=vibrato-test-sydney-keypair`
#####Number of EC2 instances to span up
* `ECS_CLUSTER_SIZE=2`
#####Size/type of instance
* `ECS_INSTANCE_TYPE=t3.small`

#####Define the VPC Availability Zones to be used (2) and CIDR
* `ECS_CLUSTER_AZS1=ap-southeast-2a`
* `SUBNET_ID_1_TAG="${ECS_VPC_TAG_NAME}_SUBNET_AZS_1"`
* `ECS_CLUSTER_AZS1_CIDR=10.0.1.0/24`
* `ECS_CLUSTER_AZS2=ap-southeast-2b`
* `SUBNET_ID_2_TAG="${ECS_VPC_TAG_NAME}_SUBNET_AZS_2"`
* `ECS_CLUSTER_AZS2_CIDR=10.0.2.0/24`

##### IGW Tag
* `ECS_IGW_TAG=ECS_IGW_TAG`

<!--
Example:

``` toml
"DbUser" = "postgres"
"DbPassword" = "changeme"
"DbName" = "app"
"DbPort" = "5432"
"DbHost" = "localhost"
"ListenHost" = "localhost"
"ListenPort" = "3000"
```

* `DbUser` - the user used to connect to the database server
* `DbPassword` - the password used to connect to the database server
* `DbName` - name of the database to use on the database server
* `DbPort` - port to connect to the database server on
* `DbHost` - host to connect to, ip or dns entry
* `ListenHost` - listener configuration for the application, 0.0.0.0 for all IP, or specify ip to listen on
* `ListenPort` - port to bind on the local server

## Environment Variables

The application will look for environment variables that are able to override the configuration defined in the `conf.toml` file. These environment varaibles are prefixed with `VTT` and follow this pattern `VTT_<conf value>`. e.g. `VTT_LISTENPORT`.

Environment variables has precedence over configuration from the `conf.toml` file

More details on each of the configuration values can be found in the section on the configuration file.
-->