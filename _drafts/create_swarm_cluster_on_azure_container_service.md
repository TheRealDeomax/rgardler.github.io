---
layout: post
title: Create a Docker Swarm Cluster on Azure Container Service
tags: [docker, swarm, acs, azure, containers]
---

Microsoft have launched a preview of their Azure Container Service
(ACS). In this post I'll look at how to create an instance of ACS
with Docker Swarm as the orchestrator using the Azure portal.

# What you need

You will need an Azure Subscription and you will need to be
whitelisted for the preview. To have your subscription whitelisted
fill in the [self nomination form](http://aka.ms/acspreview). If you
don't yet have a subscription you can start an [Azure Free
Trial](http://www.windowsazure.com/en-us/pricing/free-trial/?WT.mc_id=AA4C1C935).

You will also need an SSH key. If you don't already have one then you
can follow the [SSH on
Linux](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-use-ssh-key/)
or [SSH on
Windows](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-use-ssh-key/)
tutorial.

# Azure Resource Manager Templates

The easiest way to deploy an instance of Azure Container Service is to
use one of the provided Azure Resource Manager templates. There are a
number provided in GitHub, the one we will use in this template is the
[full Swarm template](http://aka.ms/dockerswarm). To get started click
the deploy button at the top of the readme for that repository:

![The Deploy to Azure Button]({{ site.url }}/media/swarm/deploy_to_azure_button.png)

Once you click on this button you will be taken to the Azure portal
where you can configure your Azure Container Service. There are 4
simple steps required to perform this configuration. For power users
it is possible to script this process, but for this demo we will use
the portal provided GUI.

## Step 1: Edit Parameters

The first step is to define the parameters of your service. These
parameters are:

<table>
  <tr>
    <th>Parameter</th>
    <th>Description</th>
    <th>Recommended Value</th>
  </tr>
  <tr>
    <td>DNSNAMEPREFIX</td>
    <td>Prefix for the domain names assigned to the cluster (see below)</td>
    <td>World unique string </td>
  </tr>
  <tr>
    <td>AGENTCOUNT</td>
    <td>Number of agents required in the service</td>
    <td>1-40</td>
  </tr>
  <tr>
    <td>MASTERCOOUNT</td>
    <td>Number of masters required in the service</td>
    <td>1, 3 or 5 </td>
  </tr>
  <tr>
    <td>AGENTVMSIZE</td>
    <td>Size of virtual machines to use for Agents</td>
    <td>A1 (1 core), A2 (2 core), A3 (4 core), A4 (8 core) </td>
  </tr>
  <tr>
    <td>SSHRSAPUBLICKEY</td>
    <td>Public SSH Key</td>
    <td>All three parts, looking something like 'ssh-rsa A12B34CE..123AB45D username@domain'</td>
  </tr>
</table>

Once completed your parameters will look something like this:

![ACS Swarm parameters]({{ site.url }}/media/swarm/acs_swarm_parameters.png)

## Step 2: Select or Create a Resource Group

Click OK on the parameters blade and ensure the correct Azure
subscription is selected. Then either select an existing resource
group or click the "Or create new" link and enter a name for your new
resource group (a logical grouping of resources in Azure, if you don't
know what this is then simply create a new one).

## Step 3: Select a Deployment Region

At the time of writing ACS is only available in Japan East, more
regions will be available in the near future. If you have an option
then select your preferred region.

## Step 4: Reveiew Legal Terms and Create Your Service

Finally, review the legal terms and click "Create" in the deployment
blade. You will be returned to the portal dashboard and will ahve an
animated tile indicating that your service it being deployed. Once
completed you will be taken to the Resource Group view that contians
your container service.

# Connecting to the Service with the Docker CLI

