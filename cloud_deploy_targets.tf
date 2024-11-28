resource "google_clouddeploy_target" "targets" {
  for_each = var.gcp_cloud_deploy_targets != null ? { for target in var.gcp_cloud_deploy_targets : target.name => target } : {}

  location         = each.value.location
  name             = each.value.name
  description      = lookup(each.value, "description", null)
  require_approval = lookup(each.value, "require_approval", false)
  project          = var.project_id
  provider         = google-beta

  dynamic "run" {
    for_each = contains(keys(each.value), "run") && each.value.run != null ? [each.value.run] : []
    content {
      location = run.value.location
    }
  }

  dynamic "gke" {
    for_each = contains(keys(each.value), "gke") && each.value.gke != null ? [each.value.gke] : []
    content {
      cluster     = gke.value.cluster
      internal_ip = lookup(gke.value, "internal_ip", null)
    }
  }
  /*
  dynamic "execution_configs" {
    for_each = contains(keys(each.value), "execution_configs") && each.value.execution_configs != null ? each.value.execution_configs : []
    content {
      usages = execution_configs.value.usages
    }
  }
  */

  labels = lookup(each.value, "labels", {})
}

