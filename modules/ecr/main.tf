resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name

}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only keep the last 5 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
