# Restart dead or hung instance

resource "null_resource" "check_alarm_action" {
  count = var.disable_alarm_action ? 0 : local.instance_count

  triggers = {
    action = "arn:${try(data.aws_partition.default[0].partition, null)}:swf:${local.region}:${try(data.aws_caller_identity.default[0].account_id, null)}:${var.default_alarm_action}"
  }
}

resource "aws_cloudwatch_metric_alarm" "default" {
  count = var.disable_alarm_action ? 0 : local.instance_count

  alarm_name          = module.this.id
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = var.applying_period
  statistic           = var.statistic_level
  threshold           = var.metric_threshold
  depends_on          = [null_resource.check_alarm_action]
  treat_missing_data  = var.metric_treat_missing_data

  dimensions = {
    InstanceId = one(aws_instance.default[*].id)
  }

  alarm_actions = [
    null_resource.check_alarm_action[count.index].triggers.action
  ]

  tags = module.this.tags
}
