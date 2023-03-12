resource "aws_security_group" "cluster_sg" {
  ingress = [{
    cidr_blocks      = []
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = true
    to_port          = 0
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

module "master_node" {
  source                = "./master_node"
  cluster_prefix        = var.cluster_prefix
  master_node_number    = var.master_node_number
  cluster_sg_id         = aws_security_group.cluster_sg.id
  vpc                   = var.vpc
  public_subnet_ids     = var.public_subnet_ids
  instance_type         = var.instance_type
  ubuntu_ami            = var.ubuntu_ami
  ec2_instance_profile  = var.ec2_instance_profile
  key_name              = var.key_name
  install_k8s_user_data = var.install_k8s_user_data
}

module "worker_node" {
  source                = "./worker_node"
  cluster_prefix        = var.cluster_prefix
  worker_node_number    = var.worker_node_number
  cluster_sg_id         = aws_security_group.cluster_sg.id
  vpc                   = var.vpc
  private_subnet_ids    = var.private_subnet_ids
  instance_type         = var.instance_type
  ubuntu_ami            = var.ubuntu_ami
  ec2_instance_profile  = var.ec2_instance_profile
  key_name              = var.key_name
  install_k8s_user_data = var.install_k8s_user_data
}
