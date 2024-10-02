module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"
  
  name = "ec2-jump"
  instance_type = "t2.micro"
  
  user_data = <<-EOF
    #!/bin/bash
    yum install -y https://s3.${var.region}.amazonaws.com/amazon-ssm-${var.region}/latest/linux_amd64/amazon-ssm-agent.rpm
    yum install -y yum-utils shadow-utils
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    yum install -y terraform
    yum install -y docker
    mkdir /home/ec2-user/dev && chown ec2-user /home/ec2-user/dev
    usermod -aG docker ec2-user
    systemctl start amazon-ssm-agent
    systemctl start docker
    EOF

  availability_zone = element(module.basic_vpc.azs, 0)
  subnet_id = element(module.basic_vpc.public_subnets, 0)

  associate_public_ip_address = true
  vpc_security_group_ids = [module.allow-ssh_sg.security_group_id]

  iam_instance_profile = resource.aws_iam_instance_profile.ssm_managed_ec2.name

  depends_on = [module.basic_vpc, module.allow-ssh_sg, resource.aws_iam_instance_profile.ssm_managed_ec2]
}

module "allow-ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow-ssh"
  description = "allow-ssh (dev)"
  vpc_id      = module.basic_vpc.vpc_id

  # https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest#input_rules
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}


