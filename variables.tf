variable "project_id" {
  description = "ID del proyecto GCP donde se crearán los targets de Cloud Deploy."
  type        = string
}

variable "gcp_cloud_deploy_targets" {
  description = "Lista de configuraciones para los targets de Cloud Deploy. Puede estar vacía."
  type = list(object({
    name             = string
    location         = string
    description      = optional(string)
    require_approval = optional(bool)
    run = optional(object({
      location = string
    }))
    gke = optional(object({
      cluster     = string
      internal_ip = optional(bool)
    }))
    /*
    execution_configs = optional(list(object({
      usages = list(string)
    })))
    */
    labels = optional(map(string))
  }))
  default = []
}



variable "gcp_cloud_deploy_pipelines" {
  description = "Lista de configuraciones para los delivery pipelines. Si no se especifica, no se creará ningún pipeline."
  type = list(object({
    location              = string
    name                  = string
    description           = optional(string, "A description of the delivery pipeline.")
    # deploy_parameters     = map(string)
    # match_target_labels   = map(string)
    # profiles              = list(string)
    target_id             = string
    # additional_profiles   = list(string)
    # additional_target_id  = string
    annotations           = map(string)
    labels                = map(string)
  }))
  default = []
}
