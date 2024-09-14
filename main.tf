terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
    }
    time = {
      source = "hashicorp/time"
    }
    sshcommand = {
      source = "invidian/sshcommand"
    }
  }
}