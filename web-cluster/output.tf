output "lb_dns_name" {
  description = "DNS Name of the load balancer"
  value       = aws_lb.tech_test_lb.dns_name
}
