output "single_ec2_ip" {
  value = aws_instance.single_ec2.public_ip
}

output "flask_ec2_ip" {
  value = aws_instance.flask_ec2.public_ip
}

output "express_ec2_ip" {
  value = aws_instance.express_ec2.public_ip
}