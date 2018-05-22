# Restart dead or hung instance

locals {
  action = "arn:aws:swf:${var.region}:${data.aws_caller_identity.default.account_id}:${var.default_alarm_action}"
}

resource "aws_cloudwatch_metric_alarm" "default" {
  count               = "${length(aws_instance.default.*.id)}"
  alarm_name          = "${module.label.id}-${count.index}"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.metric_namespace}"
  period              = "${var.applying_period}"
  statistic           = "${var.statistic_level}"
  threshold           = "${var.metric_threshold}"

  dimensions {
    InstanceId = "${element(sort(aws_instance.default.*.id), count.index)}"
  }

  alarm_actions = [
    "${local.action}",
  ]
}
