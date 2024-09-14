

resource "ssh_resource" "update_cgroups_agents" {
  when = "create"

  for_each = {
    for index, i in var.agent_hosts :
    i.host => i
  }

  host     = each.value.host
  user     = coalesce(each.value.user, var.server_user)
  password = coalesce(each.value.password, var.server_password)

  commands = [
    "sudo sed -i -e '$s/$/ cgroup_memory=1 cgroup_enable=memory/' /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}

resource "ssh_resource" "delete_cgroups_agents" {
  depends_on = [null_resource.agents]
  when       = "destroy"

  triggers = {
    host     = each.value.host
    user     = coalesce(each.value.user, var.server_user)
    password = coalesce(each.value.password, var.server_password)
  }

  for_each = {
    for index, i in var.agent_hosts :
    i.host => i
  }

  host     = each.value.host
  user     = coalesce(each.value.user, var.server_user)
  password = coalesce(each.value.password, var.server_password)

  commands = [
    "sudo sed -e 's/cgroup_memory=1 cgroup_enable=memory//g' -i /boot/firmware/cmdline.txt",
    "sudo reboot"
  ]
}

