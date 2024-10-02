resource "aws_iam_role" "ssm_role" {
  name_prefix = "AmazonSSMManagedInstanceRole-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_managed_ec2" {
  name_prefix = "AmazonSSMManagedInstanceProfile-"
  role = resource.aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role      = resource.aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AdministratorAccess" {
  role    = resource.aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}