### Create bastion host using terraform

How to run this?

Clone this repository and change directory into cloned repository

Bastion hosts require few shh keys to be generated to start the service. To generate keys run the following the script

    # this generates a folder names keys and adds all required keys to apply terraform plan
    ./keygen.sh

After generating the keys add terraform.tfvars file to include your amazon access key and parameters

Now run terraform plan. (shows you what aws resources are going to be generated)

    terraform plan

Now build infra on aws using terraform apply.

    terraform apply