output "cloud_deploy_targets" {
  description = "Información de los targets creados."
  value       = google_clouddeploy_target.targets
}


output "pipeline_names" {
  description = "Los nombres de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.name]
}

output "pipeline_ids" {
  description = "Los IDs de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.id]
}

output "pipeline_locations" {
  description = "Las ubicaciones de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.location]
}
