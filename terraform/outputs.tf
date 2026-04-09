output "fullstack_ec2_ip" {
  value = aws_instance.fullstack.public_ip
}