terraform {
  required_version = "> 0.12.26"
  # backend "local" {} 
  # backend "azurerm" {}  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}