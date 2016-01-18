---
layout: post
title: Sharing Files Between Linux Hosts on Azure
tags: [Azure, Linux]
---

Azure File Service provides a way to work with files that are common
across multiple Virtual Machiens or Containers on Azure. In this post
I'll show how to mount shared directories on Linux Virtual
Machines. In this post we'll use the Azure CLI for all actions, though
you can do most of this in the portal too. 

# Install the Azure CLI

If you already have the Azure CLI then ensure it is the latest version
(`sudo npm update azure-cli`) and skip forward to the next section. If
you don't yet have the CLI then install node and then run the
following commands.

{% highlight bash %}
sudo npm install -g azure-cli
{% endhighlight %}

# Login to Azure

We'll be using the Azure Resource Manager to create and manage our
Files Service, so we need to set the mode and login to Azure:

{% highlight bash %}
azure config mode arm
azure login
{% endhighlight %}

# Create a Storage Account

If you don't already have a resource group and storage account you
will need to create them:

{% highlight bash %}
azure group create -l "Japan East" acstest
info:    Executing command group create
+ Getting resource group acsdummy
+ Creating resource group acsdummy
info:    Created resource group acsdummy
data:    Id:                  /subscriptions/325e7c34-99fb-4190-aa87-1df746c67705/resourceGroups/acsdummy
data:    Name:                acsdummy
data:    Location:            japaneast
data:    Provisioning State:  Succeeded
data:    Tags: null
data:
info:    group create command OK

azure storage account create --type LRS -l "Japan East" -g acstestfiles acstestfiles
info:    Executing command storage account create
+ Creating storage account
info:    storage account create command OK
{% endhighlight %}

# Create a File Share

Now that we have a Storage Account we will create a fileshare within it:

{% highlight bash %}
azure storage account keys list acstestfiles
info:    Executing command storage account keys list
Resource group name: acstestfiles
+ Getting storage account keys
data:    Primary: JwFtVAcgbnHvJsk2d/isLsCuqkKJmah+25MdSiS7x2+6YV//A8HyHGktahmr9/uEPfkG9Zkcad8GgZi2Fqw6og==
data:    Secondary: 965FQ1p8SioeCq8GJ90ax6BYtnfeWPWDHmr5YLqH20WbbR800D/ym/29DhbK5WQqVsYNcVzBoFGhQRU2JQcbJA==
info:    storage account keys list command OK
$ azure storage share create -a acstestfiles -k JwFtVAcgbnHvJsk2d/isLsCuqkKJmah+25MdSiS7x2+6YV//A8HyHGktahmr9/uEPfkG9Zkcad8GgZi2Fqw6og== acstestshare
info:    Executing command storage share create
+ Creating storage file share acstestshare
+ Getting Storage share information
data:    {
data:        name: 'acstestshare',
data:        metadata: {},
data:        etag: '"0x8D31FB91EB2E415"',
data:        lastModified: 'Mon, 18 Jan 2016 03:40:33 GMT',
data:        requestId: '66bacd33-001a-0001-28a1-511866000000',
data:        quota: '5120',
data:        shareUsage: '0'
data:    }
info:    storage share create command OK
{% endhighlight %}

# Mount the Share on a Linux VM

The endpoint of your Files Service is structured as
https://[ACCOUNT_NAME].file.core.windows.net/. If in doubt you can
retrieve it using the CLI as follows:

{% highlight bash %}
$ azure storage account show acstestfiles
info:    Executing command storage account show
Resource group name: acstestfiles
+ Getting storage account
data:    Name: acstestfiles
data:    Url: /subscriptions/325e7c34-99fb-4190-aa87-1df746c67705/resourceGroups/acstestfiles/providers/Microsoft.Storage/storageAccounts/acstestfiles
data:    Type: Standard_LRS
data:    Resource Group: acstestfiles
data:    Location: japaneast
data:    Provisioning State: Succeeded
data:    Primary Location: japaneast
data:    Primary Status: available
data:    Secondary Location:
data:    Creation Time: 2016-01-15T18:54:14.7993195Z
data:    Primary Endpoints: blob https://acstestfiles.blob.core.windows.net/
data:    Primary Endpoints: queue https://acstestfiles.queue.core.windows.net/
data:    Primary Endpoints: table https://acstestfiles.table.core.windows.net/
data:    Primary Endpoints: file https://acstestfiles.file.core.windows.net/
info:    storage account show command OK
{% endhighlight %}

Once you are sure of your File Service endpoint you can mount it on
your Linux Virtual Machine (note the VM needs to be in the same region
as the storage account).:

{% highlight bash %}
sudo apt-get install cifs-utils
sudo mkdir -p /mnt/azure/acstests
sudo mount -t cifs //acstestfiles.file.core.windows.net/acstestshare /mnt/azure/acstests -o vers=2.1,username=acstestfiles,password=JwFtVAcgbnHvJsk2d/isLsCuqkKJmah+25MdSiS7x2+6YV//A8HyHGktahmr9/uEPfkG9Zkcad8GgZi2Fqw6og==
{% endhighlight %}

# Test it's working

Now create a file in `/mnt/azure/acstests` and then look to see that it exists from another machine. You can use the portal, another VM on which you have mounted the share or you can use the following commands:

{% highlight bash %}
azure storage file list -a acstestfiles -k JwFtVAcgbnHvJsk2d/isLsCuqkKJmah+25MdSiS7x2+6YV//A8HyHGktahmr9/uEPfkG9Zkcad8GgZi2Fqw6og== acstestshare
{% endhighlight %}

