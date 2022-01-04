resource "aws_sqs_queue" "sync_subscription" {
  name = "rbi-${var.stage}-${var.brand}-template-sync-subscription"

  message_retention_seconds  = 86400 # 1 day
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 300 # 5 minutes

  tags = local.common_tags
}
