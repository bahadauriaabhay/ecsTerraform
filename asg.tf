#resource "aws_placement_group" "test" {
#  name     = "test"
#  strategy = "cluster"
#}

resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
 # placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [aws_subnet.public_us_east_1a.id, aws_subnet.public_us_east_1b.id]
# target_group_arns         = [aws_lb_target_group.test.arn]

}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-0fe77b349d804e9e6"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=example >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;

EOF
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name

  lifecycle {
    create_before_destroy = true
  }
}