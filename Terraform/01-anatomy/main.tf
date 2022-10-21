provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo0" {
  name     = "demo0"
  location = "East US"
}


resource "azurerm_service_plan" "plan0" {
  name                = "plan0"
  resource_group_name = azurerm_resource_group.demo0.name
  location            = azurerm_resource_group.demo0.location
  os_type             = "Linux"
  sku_name            = var.environment == "dev" ? "F1" : "P1V2"
}


resource "azurerm_linux_web_app" "terraformdemoapp0" {
  name                = local.appservicename
  resource_group_name = azurerm_resource_group.demo0.name
  location            = azurerm_service_plan.plan0.location
  service_plan_id     = azurerm_service_plan.plan0.id

  site_config {
      always_on = var.environment != "dev" 
  }
}