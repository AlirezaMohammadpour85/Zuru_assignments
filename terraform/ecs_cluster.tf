resource "aws_ecs_cluster" "go_api_cluster" {
  name = var.ecs_cluster_name
}
