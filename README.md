Welcome to my tutorial on creating a MineCraft Sever using infrastructure provisioning script [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) and the server will be hosted on an [AWS](https://aws.amazon.com/) EC2 instance. It is necessary to have an AWS account already as we will be using its CLI in conjuction with Terraform for deployment. Terraform will create an AWS EC2 instance then run a script on that server. This script will install java and setup a minecraft server to be managed by systemctl.

# Requirements
Everything below will need to be downloaded and set up in order to follow along these instructions.
- Download [Terraform-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and follow the instructions to set up the PATH for Terraform.
- Download [AWS-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and follow instructions to set it up.
    - You need to configure AWS-cli with the credentials of your AWS account if it is not already.
    - Locate your aws_access_key_id, aws_secret_access_key, and aws_session_token. 
    - create a file ~/.aws/credentials and put the three variables in it like this
        [default]
        aws_access_key_id=<access_key>
        aws_secret_access_key=<secret_access_key>
        aws_session_token=<session_token>

# Deploying
Start by first initializing terraform.
In the directory 