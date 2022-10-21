terraform {
  backend "azurerm" {
    resource_group_name  = "terraformdemo-5-externalstate"
    storage_account_name = "terraformdemo05state"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}