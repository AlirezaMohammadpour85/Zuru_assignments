

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "my-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_a_cidr_block
  availability_zone = var.availability_zone_a
  tags = {
    Name = "my-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_b_cidr_block
  availability_zone = var.availability_zone_b
  tags = {
    Name = "my-subnet-b"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-route-table"
  }
}

# Create a Route
resource "aws_route" "r" {
  route_table_id         = aws_route_table.r.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate the Route Table with Subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.r.id
}

# Create Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow inbound traffic from anywhere (for the proxy)
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block] # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ECR repository
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repository_name
}

# Create an ECS cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

# Create an IAM role for ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

# Attach the ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an IAM role for ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

# Attach the ECS Task Role Policy (You might need to customize this policy based on your application's needs)
resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/task-role/AmazonECSTaskExecutionRolePolicy" #  Consider customizing this!
}

# Create an ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family             = "my-go-app-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name = "my-go-app-container",
      image = "${aws_ecr_repository.app_repo.repository_url}:latest", #  You'll need to push your Go app image to ECR
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080
        }
      ],
      essential = true,

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group                       = "/ecs/my-go-app-task",
          awslogs-region                      = var.aws_region,
          awslogs-stream-prefix = "my-go-app"
        }
      }
    },
    {
      name = "nginx-proxy-container",
      image = "nginx:latest",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ],
      essential = true,
      dependsOn = [
        {
          containerName = "my-go-app-container"
          condition     = "HEALTHY" # Or "START" if you don't have health checks
        }
      ],
      mountPoints = [ # Mount the Nginx configuration
        {
          containerPath = "/etc/nginx/nginx.conf"
          sourceVolume    = "nginx-config"
          readOnly      = true
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group                       = "/ecs/my-go-app-task",
          awslogs-region                      = var.aws_region,
          awslogs-stream-prefix = "nginx-proxy"
        }
      }
    }
  ])

  volume { # Define the volume for Nginx config
    name      = "nginx-config"
    host_path = "/var/lib/config" # This path doesn't matter for Fargate
  }
}

# Create an ECS Service
resource "aws_ecs_service" "app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true # Or false depending on your needs
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy, aws_iam_role_policy_attachment.ecs_task_policy]
}