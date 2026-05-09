data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "vanlife-cluster-2471001"
}

resource "aws_cloudwatch_log_group" "vanlife_logs" {
  name              = "/ecs/vanlife-2471001"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "app" {
  family                   = "vanlife-task-2471001"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "haroune07/vanlife-frontend:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.vanlife_logs.name
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "frontend"
        }
      }
    },
    {
      name      = "api"
      image     = "haroune07/vanlife-api:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_PORT"
          value = "3306"
        },
        {
          name  = "DB_USER"
          value = "admin"
        },
        {
          name  = "DB_PASSWORD"
          value = "Vanlife123!"
        },
        {
          name  = "DB_NAME"
          value = "vanlife"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.vanlife_logs.name
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "api"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "vanlife-service-2471001"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.public[*].id
    assign_public_ip = true
  }
}
