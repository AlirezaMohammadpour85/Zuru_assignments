output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_a_id" {
  description = "ID of Subnet A"
  value       = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  description = "ID of Subnet B"
  value       = aws_subnet.subnet_b.id
}