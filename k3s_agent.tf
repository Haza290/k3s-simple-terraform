locals {
  k3s_token = null
}

data "sshcommand_command" "k3s_token" {
  depends_on = [ssh_resource.k3s_server_create]
  host       = var.server_host
  user       = var.server_user
  password   = var.server_password
  command    = "sudo cat /var/lib/rancher/k3s/server/node-token"
}

resource "null_resource" "agents" {
  depends_on = [data.sshcommand_command.k3s_token]

  triggers = {
    host     = each.value.host
    user     = coalesce(each.value.user, var.server_user)
    password = coalesce(each.value.password, var.server_password)
  }

  for_each = {
    for index, i in var.agent_hosts :
    i.host => i
  }

  connection {
    type     = "ssh"
    host     = self.triggers.host
    user     = self.triggers.user
    password = self.triggers.password
  }

  provisioner "remote-exec" {
    inline = [
      "touch token",
      "sudo sed -i -e '$s/$/${data.sshcommand_command.k3s_token.result}/' token",
      "curl -sfL https://get.k3s.io | K3S_URL=https://${var.server_host}:6443 K3S_TOKEN=${data.sshcommand_command.k3s_token.result} sh -"
    ]
  }

  provisioner "remote-exec" {
    when = destroy

    inline = [
      "/usr/local/bin/k3s-agent-uninstall.sh"
    ]
  }
}