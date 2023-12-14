resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {Name = "${local.name_prefix}-sg" })

  ingress {
    description      = "APP"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.ssh_ingress_cidr
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
resource "aws_launch_template" "main" {
  name_prefix   = local.name_prefix
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags, {Name = "${local.name_prefix}-ec2" })
  }

  user_data = filebase64(templatefile("${path.module}/userdata.sh",
    {
      component = var.component
    }))
}

resource "aws_autoscaling_group" "main" {
  vpc_zone_identifier = var.subnet_ids
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}