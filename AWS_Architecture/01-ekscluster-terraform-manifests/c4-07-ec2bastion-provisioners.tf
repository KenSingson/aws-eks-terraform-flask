# Create NULL resource and provisioner
resource "null_resource" "copy_ec2_keypairs" {
  depends_on = [
    module.ec2_public
  ]

  connection {
    type = "ssh"
    host = aws_eip.bastion_eip.public_ip
    user = "ec2-user"
    private_key = file("private-key/udemy-eks-kp.pem")
  }

  # FILE PROVISIONERS
  # to copy files in newly created resources
  provisioner "file" {
    source = "private-key/udemy-eks-kp.pem"
    destination = "/tmp/udemy-eks-kp.pem"
  }

  # REMOTE PROVISIONER
  # change permission of the copied keypair
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/udemy-eks-kp.pem"
    ]
  }
}