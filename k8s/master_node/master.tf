resource "aws_security_group" "master_ssh_sg" {
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  vpc_id = var.vpc.id
}


resource "aws_instance" "master_node" {
  count                  = var.master_node_number
  ami                    = var.ubuntu_ami.id
  instance_type          = var.instance_type
  iam_instance_profile   = var.ec2_instance_profile
  key_name               = var.key_name
  subnet_id              = var.public_subnet_ids[count.index%length(var.public_subnet_ids)]
  vpc_security_group_ids = [var.cluster_sg_id, aws_security_group.master_ssh_sg.id]
  user_data = var.install_k8s_user_data
  tags = {
    "Name" = "${var.cluster_prefix}-master-${count.index}"
  }
}
