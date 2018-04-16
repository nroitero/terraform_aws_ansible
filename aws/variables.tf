variable "region" {
  description = "The AWS region."
}

variable "instance_type" {
  description = "The instance type."
  default     = "t2.micro"
}

variable "server_count" {
  description = "number of server running app"

  default = "2"
}

variable "domain" {
  default = "example.com"
}

variable "ansible_verbosity" {
  default = ""
}
