# Define Variables here

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = "vpc-66bb3b00"
}

variable "service" {
  description = "Name of the service"
  type        = string
  default     = "tech-test"
}

variable "region" {
  description = "The AWS Region to build in"
  type        = string
  default     = "eu-west-1"
}

variable "elb_port" {
  description = "The Port Number the ELB will be listening on"
  type        = number
  default     = 80
}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "cpu_min_threshold" {
  description = "The minumum threshold for the CPU, at which we scale down"
  type        = string
  default     = 5
}

variable "cpu_max_threshold" {
  description = "The maxumum threshold for the CPU, at which we scale up"
  type        = string
  default     = 30
}
