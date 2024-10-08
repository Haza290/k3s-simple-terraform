variable "server_password" {
  description = "k3s server hosts password"
  type        = string
  sensitive   = true
}

variable "server_host" {
  description = "k3s server host"
  type        = string
  default     = "piMaster"
}

variable "server_user" {
  description = "k3s server's user"
  type        = string
  default     = "harry"
}

variable "agent_hosts" {
  description = "list of k3s agents"
  type = list(object({
    host     = string
    user     = optional(string, null)
    password = optional(string, null)
  }))
  default = [null]
}
