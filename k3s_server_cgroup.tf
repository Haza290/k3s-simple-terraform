resource "ssh_resource" "update_cgroup_server" {
  when = "create"

  host     = var.server_host
  user     = var.server_user
  password = var.server_password

  commands = [
    "sudo sed -i -e '$s/$/ cgroup_memory=1 cgroup_enable=memory/' /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}

resource "ssh_resource" "delete_cgroup_server" {
  when       = "destroy"
  depends_on = [ssh_resource.k3s_server_destroy]

  host     = var.server_host
  user     = var.server_user
  password = var.server_password

  commands = [
    "sudo sed -e 's/cgroup_memory=1 cgroup_enable=memory//g' -i /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}