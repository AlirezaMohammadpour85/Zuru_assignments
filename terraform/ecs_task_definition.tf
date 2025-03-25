resource "aws_ecs_task_definition" "go_api_task" {
  family                   = "go-api-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "go-api-container"
      image     = "${aws_ecr_repository.go_api_repo.repository_url}:${var.go_api_image_name}"
      cpu       = 128
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    },
    {
      name      = "nginx-proxy-container"
      image     = "${aws_ecr_repository.go_api_repo.repository_url}:${var.nginx_proxy_image_name}"
      cpu       = 128
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
