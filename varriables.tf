variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "Germany West Central"
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "vm_admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}
