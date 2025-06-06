#########################
# Key pair EC2 -> Outputs
#########################

output "key_name" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.ssh_key.key_name
}
