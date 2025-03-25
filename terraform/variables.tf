# AWS region - start
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}
# AWS region - end

# aws credentials profile info -start
variable "shared_credentials_files" {
  description = "Path to shared credentials file"
  default     = "~/.aws/credentials"
}

variable "profile_name" {
  description = "AWS profile name"
  default     = "terraform_user"
}
# aws credentials profile info -end

# ECR Repository Name - start
variable "ecr_repo_name" {
  description = "ECR repository name"
  default     = "go-api-repo"
}

variable "go_api_image_name" {
  description = "api image name"
  default     = "go-api-image"
}
variable "nginx_proxy_image_name" {
  description = "nginx proxy image name"
  default     = "nginx-proxy-image"
}
# ECR Repository Name - start

# ECS Cluster Name - start
variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  default     = "go-api-cluster"
}
# ECS Cluster Name - end
