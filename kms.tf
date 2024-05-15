##################################
# Key for encrypt SSM Parameters #
##################################

resource "aws_kms_key" "ssm" {
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = "7"
  description             = "KMS key for encrypt ssm parameters"
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/-${var.region}-kms-ssm-parameter"
  target_key_id = aws_kms_key.ssm.id
}
