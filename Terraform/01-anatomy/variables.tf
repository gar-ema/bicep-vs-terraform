variable "appname" {
    type        = string
    description = "Name of the app"
}

variable "appresx-prefix" {
    type        = string
    description = "Prefix to be used for resources name"
}

variable "location" {
    type        = string
    description = "Azure Region"
}

variable "environment" {
    validation {
    condition     = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Valid values for environment are (dev, tst, prd)."
  } 
  type        = string
  description = "Target environment"
}

