locals {
  branch_name              = terraform.workspace == "dev" ? "dev" : "main"
}

data "aws_s3_bucket" "artifact_store" {
  bucket = var.artifact_store_location
}

data "aws_codestarconnections_connection" "codestar_connection" {
  name = var.codestar_connection_name
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.namespace}-${local.stage}-code-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = data.aws_s3_bucket.artifact_store.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.codestar_connection.arn
        FullRepositoryId = var.repository_name
        BranchName       = local.branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = module.ecs_cluster.cluster_name
        ServiceName = module.ecs_service.ecs_service_name
      }
    }
  }
}






#IAM Role

data "aws_iam_policy_document" "code_pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.namespace}-${local.stage}-code-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      "${data.aws_s3_bucket.artifact_store.arn}/*",
      data.aws_s3_bucket.artifact_store.arn,
    ]

  }

  statement {
    effect  = "Allow"
    actions = ["codestar-connections:UseConnection"]
    resources = [
      data.aws_codestarconnections_connection.codestar_connection.arn,
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["ecs:*"]
    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}


resource "aws_codebuild_project" "code_build" {
  name         = "${var.namespace}-${local.stage}-code-build"
  description  = "Code build for ${var.namespace}-${local.stage}"
  service_role = aws_iam_role.code_build_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type     = "BUILD_GENERAL1_SMALL"
    image            = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type             = "LINUX_CONTAINER"
    privileged_mode  = true
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-${local.stage}.yml"
  }
  tags = {
    Name = "${var.namespace}-${local.stage}-code-build"
  }



}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code_build_role" {
  name               = "${var.namespace}-${local.stage}-code-build-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "code_build_policy" {

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      "${data.aws_s3_bucket.artifact_store.arn}/*",
      data.aws_s3_bucket.artifact_store.arn,
    ]

  }

  statement {
    effect  = "Allow"
    actions = ["ecr:*"]
    resources = [
     "*",
    ]
  }
}

resource "aws_iam_role_policy" "code_build_policy" {
  name   = "${var.namespace}-${local.stage}-code-build-policy"
  role   = aws_iam_role.code_build_role.id
  policy = data.aws_iam_policy_document.code_build_policy.json
}
