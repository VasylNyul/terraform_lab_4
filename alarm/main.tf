resource "aws_sns_topic" "email" {
  name = "email-sender" 
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.email.arn
  protocol  = "email"
  endpoint  = "vasyl.nul@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "this" { 
    alarm_name = "invoking-of-get-all-authors-lambda"

    actions_enabled = true
    alarm_description = "If the lambda is invoked more 10 times, than sns-resourse will send an alarm"
    statistic = "SampleCount"
    threshold = 10
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    period = 60
    namespace = "AWS/DynamoDB"
    dimensions = {
      TableName="dev-terraformlab1-lpnu-authors"
    }
    metric_name = "ConsumedReadCapacityUnits"
    alarm_actions       = [aws_sns_topic.email.arn, module.notify-slack.slack_topic_arn]
}

module "notify-slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "5.6.0"
  # insert the 4 required variables here
  slack_channel = "laba4"
  slack_username = "Nyul_Vasyl"
  slack_webhook_url = "https://hooks.slack.com/services/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"
  sns_topic_name = "Warning"
}