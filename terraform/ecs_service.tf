# use two different setvices to block access to api app directly
resource "aws_ecs_service" "go_api_service" {
  name            = "go-api-service"
  cluster         = aws_ecs_cluster.go_api_cluster.id
  task_definition = aws_ecs_task_definition.go_api_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # one subnet is required I added for redundancy in future
    security_groups  = [aws_security_group.go_api_sg.id]
    assign_public_ip = true
  }

  desired_count = 1
}

