resource "aws_sqs_queue" "terraform_queue" {
  name                      = var.name
  sqs_managed_sse_enabled   = true
  message_retention_seconds = 300
  tags                      = var.tags
}
data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid    = "EC2InterruptionPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.terraform_queue.arn]
  }
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.terraform_queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}