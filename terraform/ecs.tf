############################
# ECS CLUSTER
############################
resource "aws_ecs_cluster" "main" {
  name = "app-cluster"
}

############################
# IAM ROLE FOR ECS TASKS
############################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRoleAbhay"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################
# SECURITY GROUP FOR ECS
############################
resource "aws_security_group" "ecs_sg" {
  name   = "ecs_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# TASK DEFINITIONS
############################

# Flask Task
resource "aws_ecs_task_definition" "flask" {
  family                   = "flask-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "flask"
      image = "${aws_ecr_repository.flask_repo.repository_url}:latest"

      portMappings = [{
        containerPort = 5000
      }]
    }
  ])
}

# Express Task
resource "aws_ecs_task_definition" "express" {
  family                   = "express-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "express"
      image = "${aws_ecr_repository.express_repo.repository_url}:latest"

      portMappings = [{
        containerPort = 3000
      }]
    }
  ])
}

############################
# ECS SERVICES
############################

# Flask Service
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_tg.arn
    container_name   = "flask"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.listener]
}

# Express Service
resource "aws_ecs_service" "express_service" {
  name            = "express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.express.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_tg.arn
    container_name   = "express"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener]
}