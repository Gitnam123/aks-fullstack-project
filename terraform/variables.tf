variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "aks-fullstack-rg"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
  default     = "aks-fullstack"
}

variable "acr_name_prefix" {
  description = "ACR name prefix"
  type        = string
  default     = "aksfullstackacr"
}

variable "postgres_name_prefix" {
  description = "PostgreSQL server name prefix"
  type        = string
  default     = "aksfullstackpg"
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "pgadmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}
