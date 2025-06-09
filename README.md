Welcome to my tutorial on creating a MineCraft Sever using infrastructure provisioning script [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) and the server will be hosted on an [AWS](https://aws.amazon.com/) EC2 instance. It is necessary to have an AWS account already as we will be using its CLI in conjuction with Terraform for deployment. Terraform will create an AWS EC2 instance then run a script on that server. This script will install java and setup a minecraft server to be managed by systemctl.

The deployment pipeline works like this:

```mermaid
graph TD
    A[Terraform Apply] --> B[Create EC2 Instance]
    B --> C[Provision coppies startup.sh to server]
    C --> D[Run startup.sh]
    D --> E[Install Java 21]
    E --> F[Install Minecraft Server jar]
    F --> G[Run Minecraft server through systemd]

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
- You need a key-pair on AWS in order for terraform to be able to access the server it creates.
    - To create a new key pair, you can generate it yourself or create one on AWS.
    - To create a new key pair, in you AWS console go to the EC2 page.
    - on the left, choose 'Key Pairs' under Network & Security.
    - in the top right, choose "Create Key Pair"
    - enter 'minecraft' as the name for the key, or any other name you want.
        - if you chose a different name, you need to change the key_name in main.tf
    - choose "Create Key Pair" which will then download the private key you created.
    - put that file in the same directory that you cloned this github to.

# Deploying
Start by first initializing terraform.
In the directory where you cloned this repository run the following:

    terraform init

If everything was setup properly, you are now ready to use terraform to deploy the minecraft server. To do this is as simple as running:

    terraform apply

Type yes when promted and it will create the instance and deploy the minecraft server to that instance. When it is done, it will output the public ip that the server is on which is what is necessary to connect to it.

To connect to the server in minecraft, just connect to that public ip that was printed with :25565 at the end. Like this:

    123.45.67.89:25565

# Monitoring
To check the status of the server and change the parameters of the minecraft server you can SSH into the server with the following command:

    ssh -i minecraft.pem ec2-user@<public DNS>

Where minecraft.pem is the private key setup from requirements and <public DNS> is found on the aws EC2 console. Locate the instance that was created by terraform with name MinecraftServer and fill in <public DNS> with public DNS found there.

When you are connected to the server, you can check on the status of the minecraft server by running:

    sudo systemctl status minecraft

You should see it display as Active (running). All the parameters of the minecraft server are located at /opt/minecraft/server, so you can cd into it and change the parameters how you want.

The server is setup to be managed by systemctl meaning it wall automatically start back up if the server reboots.