variable "region" {
  type        = string
  description = "Region in which resources are deployed"
  default     = "eu-central-1"
}

variable "owner" {
  type        = string
  description = "Owner Name for Tags"
  default     = "Chirazi Ioan Alexandru"
}

variable "vpc_name" {
  type        = string
  description = "Virtual Private Network name"
  default     = "nexaspherevpc"
}

variable "list_eks" {
  type        = list
  description = "Virtual Private Network name"
  default     = [0, 1]
}

variable "list_nodes" {
  type        = list
  description = "Virtual Private Network name"
  default     = [2, 3]
}

variable "backend_s3" {
  type        = string
  description = "Bucket name where backend is stored"
  default     = "nexasphere-tf"
}