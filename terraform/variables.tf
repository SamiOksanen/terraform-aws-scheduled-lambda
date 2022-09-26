variable "TEST_ENV_VARIABLE_ONE" {
  type        = string
  description = "The application TEST_ENV_VARIABLE_ONE env var"
  sensitive   = true
  nullable    = false
}

variable "TEST_ENV_VARIABLE_TWO" {
  type        = string
  description = "The application TEST_ENV_VARIABLE_TWO env var"
  nullable    = false
}
