variable "environment_name" {
  type = string
}

variable "eks_cluster_name" {
  type    = string
  default = ""
}

variable "enable_github_oidc" {
  type    = bool
  default = false
}

variable "github_org" {
  type    = string
  default = ""
}

variable "github_repo" {
  type    = string
  default = ""
}

variable "github_branch" {
  type    = string
  default = ""
}

variable "github_environment" {
  type    = string
  default = ""
}