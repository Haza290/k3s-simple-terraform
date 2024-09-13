terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

resource "ssh_resource" "update_cgroups" {
  when = "create"

  host     = var.server_host
  user     = var.server_user
  password = var.server_password

  commands = [
    "sudo sed -i -e '$s/$/ cgroup_memory=1 cgroup_enable=memory/' /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [ssh_resource.update_cgroups]
  create_duration = "30s"
}

resource "ssh_resource" "k3s_server_create" {
  depends_on = [time_sleep.wait_30_seconds]
  when       = "create"

  host     = var.server_host
  user     = var.server_user
  password = var.server_password

  commands = [
    "curl -sfL https://get.k3s.io | sh -"
  ]
}

resource "ssh_resource" "k3s_server_destroy" {
  when = "destroy"

  host     = var.server_host
  user     = var.server_user
  password = var.server_password

  commands = [
    "/usr/local/bin/k3s-uninstall.sh",
    "sudo sed -e 's/cgroup_memory=1 cgroup_enable=memory//g' -i /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}

