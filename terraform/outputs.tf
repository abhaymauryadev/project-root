# output "fullstack_ec2_ip" {
#   value = aws_instance.fullstack.public_ip
# }

output "flask_ip" {
  value = aws_instance.flask.public_ip
}

output "express_ip" {
  value = aws_instance.express.public_ip
}