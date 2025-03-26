output "ecr_repository_url" {
  value = aws_ecr_repository.go_api_repo.repository_url
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.go_api_cluster.id
}

output "api-app-image-name" {
  value = "${aws_ecr_repository.go_api_repo.repository_url}:${var.go_api_image_name}"
}
output "nginx_proxy-image-name" {
  value = "${aws_ecr_repository.go_api_repo.repository_url}:${var.nginx_proxy_image_name}"
}
