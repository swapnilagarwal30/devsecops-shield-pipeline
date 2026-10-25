variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
  default     = "rg-prod-workload-demo"
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "eastus"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique name for storage account."
  default     = "stprodshielddemo01"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default = {
    Environment = "Production"
    ManagedBy   = "DevSecOps-Pipeline"
    Security    = "Shift-Left-Enforced"
  }
}
