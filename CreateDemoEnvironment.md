# Create Demo Environment

You can use the demoEnvironment.bicep template to create the environment for the demos.

```bash
az deployment sub create --location <azure region> --template-file demoEnvironment.bicep --parameters resourceGroupName=<resource group name> keyVaultName=<keyvault name> keyVaultResourceGroup=<kvResourceGroupname>
```

Example:

```bash
$resourceGroupName="BicepDemo-rg"
$keyVaultName="bicepVSTerraformKV"
$keyVaultResourceGroup="BicepVSTerraformKV-rg"

az deployment sub create \
    --location northeurope \
    --template-file demoEnvironment.bicep \
    --parameters resourceGroupName=$resourceGroupName \
                 keyVaultName=$keyVaultName \
                 keyVaultResourceGroup=$keyVaultResourceGroup
```


