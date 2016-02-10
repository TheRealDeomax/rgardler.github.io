---
layout: post
title: Create Keys for an Application to Manage Azure
tags: [azure, cli, service principal]
---

An application that wishes to access resources in your Azure
subscription needs a "Service Principal" in order to avoid 2-factor
authentication. This is essentially a "key" to use when authenticating
against the service. This short post explains how to create a Service
Principal using the Azure CLI.

# Authenticating Using a Password and a Service Principal

## Configure the CLI

```bash
azure config mode arm
azure login
```

## Create an application

```bash
azure ad app create --name "APPLICATION_NAME" --home-page "http://yourapp.com" --identifier-uris "http://yourapp.uri" --password YOUR_PASSWORD
```

The output will look something like:

```bash
$ azure ad app create --name vmssdashboard --home-page http://gardler.org/vmssdashboard --identifier-uris http://gardler.org/vmssdashboard --password SECRET
info:    Executing command ad app create
+ Creating application vmssdashboard
data:    AppId:                   e0135f3a-...-8f5fb24042f5
data:    ObjectId:                01dea91f-...-bfd68029faf9
data:    DisplayName:             vmssdashboard
data:    IdentifierUris:          0=http://gardler.org/vmssdashboard
data:    ReplyUrls:
data:    AvailableToOtherTenants:  False
data:    AppPermissions:
data:                             claimValue:  user_impersonation
data:                             description:  Allow the application to access vmssdashboard on behalf of the signed-in user.
data:                             directAccessGrantTypes:
data:                             displayName:  Access vmssdashboard
data:                             impersonationAccessGrantTypes:  impersonated=User, impersonator=Application
data:                             isDisabled:
data:                             origin:  Application
data:                             permissionId:  e0537df4-5982-4b44-b132-cbbd4033b7a1
data:                             resourceScopeType:  Personal
data:                             userConsentDescription:  Allow the application to access vmssdashboard on your behalf.
data:                             userConsentDisplayName:  Access vmssdashboard
data:                             lang:
info:    ad app create command OK
```

## Create a service principal for the applications

```bash
azure ad sp create APPID
```

Where APPID comes from the output of the previous step. For example:

```bash
$ azure ad sp create e0135f3a-...-8f5fb24042f5
info:    Executing command ad sp create
+ Creating service principal for application e0135f3a-...-8f5fb24042f5
data:    Object Id:               6a5f480c-...-ce77755f9bde
data:    Display Name:            vmssdashboard
data:    Service Principal Names:
data:                             e0135f3a-...-8f5fb24042f5
data:                             http://gardler.org/vmssdashboard
info:    ad sp create command OK
```

## Grant Permissions to the Service Principal

```bash
azure role assignment create --objectId OBJECT_ID -o Reader -c /subscriptions/SUBSCRIPTION_ID
```

Where OBJECT_ID comes from the output above and the SUBSCRIPTION_ID is your Azure subscription ID (which can be found with `azure account list`).

The output will look something like this:

```bash
$ azure role assignment create --objectId 6a5f480c-...-ce77755f9bde -o Reader -c /subscriptions/325e7c34-...-1df746c67705
info:    Executing command role assignment create
+ Finding role with specified name
\data:    RoleAssignmentId     : /subscriptions/325e7c34-...-1df746c67705/providers/Microsoft.Authorization/roleAssignments/f5b6dc32-...-6018484fbcc1
data:    RoleDefinitionName   : Reader
data:    RoleDefinitionId     : acdd72a7-...-f606fba81ae7
data:    Scope                : /subscriptions/325e7c34-...-1df746c67705
data:    Display Name         : vmssdashboard
data:    SignInName           :
data:    ObjectId             : 6a5f480c-...-ce77755f9bde
data:    ObjectType           : ServicePrincipal
data:
+
info:    role assignment create command OK
```

## Get the TenantId

Retrieve the TenandId for the subscription you are using.

```bash
azure account list --json
```

If you have many subscriptions you might want to use ```azure account
show SUBSCRIPTION_ID --json```.

## Sign in using the Application ID as a username

To test this is working you can sign in using the application ID as a
password.

```bash
azure login -u APPLICATION_ID -p PASSWORD --service-principal --tenant TENANT_ID
```

For example:

```bash
$ azure login -u e0135f3a-...-8f5fb24042f5 -p 3g45hRbx* --service-principal --tenant 72f98
8bf-...-2d7cd011db47
info:    Executing command login
\info:    Added subscription Microsoft Azure Internal Consumption
+
info:    login command OK
```

# Using a Service Praincipal and a Certificate

## Create a .pem file

```bash
openssl.exe pkcs12 -in examplecert.pfx -out examplecert.pem -nodes
```

## Create an Application with the certificate

```bash
azure ad app create -n "APPLICATION_NAME" --home-page "APPLICATION_URL" -i "APPLICATION_URI" --key-value CONTENTS_OF_PEM_FILE
```

# Further Reading

[Authenticating a service principal with Azure Resource Manager][service-principal]
[Azure Role-based Access Control][RBAC]


[service-principal](https://azure.microsoft.com/en-us/documentation/articles/resource-group-authenticate-service-principal/)
[RBAC][https://azure.microsoft.com/en-us/documentation/articles/role-based-access-control-configure/]