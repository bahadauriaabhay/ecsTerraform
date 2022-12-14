resource "aws_iam_role" "ecs-service-role" {
    name                = "ecs-service-role"
    path                = "/"
    assume_role_policy  = data.aws_iam_policy_document.ecs-service-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = aws_iam_role.ecs-service-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}

output "ecs-service-role-arn" {
  value = aws_iam_role.ecs-service-role.arn
}

resource "aws_ecs_service" "ecs-service" {
  	name            = "ecs-service"
  	iam_role        = aws_iam_role.ecs-service-role.arn
  	cluster         = "example"
  	task_definition = aws_ecs_task_definition.task.arn
  	desired_count   = 1

  	load_balancer {
    	target_group_arn  = aws_lb_target_group.test.arn
    	container_port    = 80
    	container_name    = "simple-app"
	}
}