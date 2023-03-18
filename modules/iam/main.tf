resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.namespace}-${var.stage}-ecs-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}




resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.namespace}-${var.stage}-ecs-task-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "statement1"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${var.bucket_arn}/*", "${var.bucket_arn}"
    ]


  }

}


resource "aws_iam_policy" "name" {
  name   = "${var.namespace}-${var.stage}-ecs-task-role-policy"
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "${var.namespace}-${var.stage}-ecs-task-role-policy-attachment"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.name.arn
}
