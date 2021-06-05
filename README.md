# azure-lab
A simple lab for performing adversary/threat emulation on Azure. 


## Introduction
I built this so I could easily (and relatively cheaply) spin up a windows environment to build CTFs, try new attacks out, and in a past life demo Elastic Security to people. 

The scripts here will deploy the following. 

- A Domain Controller
- A Windows 10 Client Machine
- It will also, create a domain and join the client to the domain
- A Kali Linux machine
- An Azure Bastion host 
- #TODO: setup vuln AD scripts to allow vulns from the get go

## Assumptions
- You have an Azure Subscription
- You have configured Terraform to work with said Azure Subscription


## Getting Started 
To get started, clone this repo. `cd` into it, and then run `ruby runner.rb` follow the prompts and away you go. A few things will happen. 
- You will be prompted to enter some text. 
- You pick if you want to plan, plan and run, or destroy your terraform environment. (This auto_approves so make sure you pick well.) #TODO: give the user a choice. 
- The script invokes terraform and will start provisioning your environnment. 

```
What do you want to call your admin user? admin-user
What do you want the admin password to be? •••••••••••••••••••••
What name do you want to use for your domain? attackrange.com
What do you want to use for the netbios domain name? attackrange
What password shall do you want to set for the Kali ssh user? •••••••••••••••••••••
What Kibana URL do you want to use? https://dd655d45ebbc4ac7993ba79c65be59d3.fleet.eastus2.azure.elastic-cloud.com:443
What enrollment token do you wish to set for Elastic Agent to authenticate with? ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
What do you want to do next? Plan and Run
```
