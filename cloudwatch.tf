data "aws_sns_topic" "sns" {
  name = "Sns-for-cloudwatch-log"
}

// Create CLoudwatch Dashboard for monitoring CPU Ec2
resource "aws_cloudwatch_dashboard" "EC2_Dashboard" {
  dashboard_name = "EC2-Dashboard"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "width": 24,
            "height": 15,
            "x": 0,
            "y": 0,
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::EC2::Instance",
                        "stat": "Maximum"
                    }
                ],
                "aggregateBy": {
                    "key": "InstanceType",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "State",
                        "value": "running"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "rowsPerPage": 8,
                    "widgetsPerRow": 2
                },
                "period": 60,
                "title": "Running EC2 Instances CPUUtilization"
            }
        }
    ]
}
EOF
}
// Create alarm for high-cpu-ec2-nat-bastion
resource "aws_cloudwatch_metric_alarm" "high_cpu_ec2_nat" {
  alarm_name          = "/final-lab/ec2-nat/high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "alarm for high cpu ec2 nat"
  actions_enabled     = "true"
  alarm_actions       = [data.aws_sns_topic.sns.arn]
  dimensions = {
      InstanceId = aws_instance.ec2_pub.id
  }
}

// Create alarm for high-cpu-ec2-ecs

resource "aws_cloudwatch_metric_alarm" "high_cpu_ec2_ecs" {
  alarm_name          = "/final-lab/ec2-ecs/high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "alarm for high cpu ec2 ecs"
  actions_enabled     = "true"
  alarm_actions       = [data.aws_sns_topic.sns.arn]
  dimensions = {
      InstanceId = aws_instance.ec2_pri.id
  }
}

// Create alarm for high-disk-ec2-ecs
resource "aws_cloudwatch_metric_alarm" "high_mem_ec2_ecs" {
  alarm_name          = "/final-lab/ec2-ecs/high-mem"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "disk_used_percent"
  namespace           = "AWS/CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "alarm for high memory ec2 ecs"
  actions_enabled     = "true"
  alarm_actions       = [data.aws_sns_topic.sns.arn]
  dimensions = {
      InstanceId = aws_instance.ec2_pri.id
  }
}