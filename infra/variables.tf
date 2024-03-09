variable "access_key" {}
variable "secret_key" {}

variable "region" {
  type        = string
  description = "Region in which resources are deployed"
}

variable "owner" {
  type        = string
  description = "Owner Name for Tags"
}

variable "vpc_name" {
  type        = string
  description = "Virtual Private Network name"
}

variable "list_eks" {
  type        = list
  description = "Virtual Private Network name"
}

variable "list_nodes" {
  type        = list
  description = "Virtual Private Network name"
}