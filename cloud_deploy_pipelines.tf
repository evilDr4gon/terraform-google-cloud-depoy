resource "google_clouddeploy_delivery_pipeline" "this" {
  for_each = { for pipeline in var.gcp_cloud_deploy_pipelines : pipeline.name => pipeline if pipeline.name != "" }

  location    = each.value.location
  name        = each.value.name
  description = each.value.description
  project     = var.project_id

  serial_pipeline {
    stages {
      /*
      deploy_parameters {
        # values              = each.value.deploy_parameters
        # match_target_labels = each.value.match_target_labels
      }
      */

      # profiles  = each.value.profiles
      target_id = each.value.target_id
    }
    /*
    stages {
      # profiles  = each.value.additional_profiles
      # target_id = each.value.target_id
    }
    */
  }

  annotations = each.value.annotations
  labels      = each.value.labels
  provider    = google-beta
}
