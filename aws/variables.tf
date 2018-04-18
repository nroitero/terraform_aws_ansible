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
  default     = "example.com"
  description = "domain name will create application hostname type app-{count.index}.{domain}"
}

variable "ansible_verbosity" {
  default     = ""
  description = "define ansible verbosity ex: -vvv"
}

variable "with_volume_attached" {
  description = "attach an ebs volume to the instances"
  default     = false
}
