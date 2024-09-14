resource "time_sleep" "wait_30_seconds" {
  depends_on      = [ssh_resource.update_cgroup_server]
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
  ]
}