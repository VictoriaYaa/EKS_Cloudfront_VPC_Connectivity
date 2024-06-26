variable "aws_region" { type = string}
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}
variable "namespace" { type = string}
variable "cluster_identity_oidc_issuer" { type = string }

variable "cluster_identity_oidc_issuer_arn" { type = string }

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether dmaineployment is enabled."
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller service account name"
}

variable "cf_name" { type = string }

variable "alb_arn" { type = string }