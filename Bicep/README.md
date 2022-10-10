# Bicep VS Terraform - Bicep Demo

This project contains the bicep templates you can use to create the demo environment.

To create the resource group and to deploy the resources you need for the project, simply run the following command:

```
az deployment group create \
    --resource-group <resourceGroup> \
    --template-file main.bicep \
    --parameters environmentName=<envName>
                 environmentType=<envType>
                 location=<location>
                 keyVaultName=<kayVaultName>                    
```

where 
- `<resourceGroup>` : The resource group to create deployment at.
- `<location>`: is the location where you want to deploy the environment. The default value is the resource Group location.
- `<envName>`: the name of the environment. It is a string between 3 and 6 chars used to create the name of the resources.
- `<envType>`: the environment type. You can choose between 'dev' and 'prod'.
- `<keyVaultName>`: the name of the key vault that stores the secrets.


You can also set these parameters:

- `location` : the location you want to deploy (by default the location is the same of your deployment)
- `resourceGroupName` : the name of the resource group (by default its value is `ServerlessFacesAnalyzer-rg`)

```
az deployment sub create --location <your region> --template-file main.bicep --parameters location=<location to deploy> resourceGroupName=<rg name>
```