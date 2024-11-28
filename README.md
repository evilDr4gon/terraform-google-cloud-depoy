# Terraform Cloud Deploy Module

Este módulo de Terraform permite la configuración de Cloud Deploy en Google Cloud Platform (GCP). Crea y configura delivery pipelines y targets para gestionar el despliegue de aplicaciones en Google Cloud.

## Requisitos

- **Terraform**: `>= 1.0.0`
- **Proveedor de GCP**: `google-beta` (versión `>= 3.5.0` o superior)
- **Cuenta en Google Cloud**: Necesitas una cuenta con permisos para crear y administrar recursos en GCP, como IAM, Service Accounts y Cloud Deploy.

## Variables

Este módulo acepta las siguientes variables de entrada:

### `project_id` (string)

El ID del proyecto en GCP donde se crearán los targets de Cloud Deploy.

| Nombre       | Descripción                               | Tipo   | Valor Predeterminado |
|--------------|-------------------------------------------|--------|----------------------|
| `project_id` | El ID del proyecto GCP.                   | `string` | N/A                  |

### `gcp_cloud_deploy_targets` (list)

Configuración para los targets de Cloud Deploy. Define la lista de targets, con sus respectivas configuraciones.

| Nombre           | Descripción                                                        | Tipo           | Valor Predeterminado |
|------------------|--------------------------------------------------------------------|----------------|----------------------|
| `name`           | Nombre del target de Cloud Deploy.                                  | `string`       | N/A                  |
| `location`       | Ubicación del target.                                              | `string`       | N/A                  |
| `description`    | Descripción del target (opcional).                                  | `string`       | `null`               |
| `require_approval` | Indica si se requiere aprobación antes de ejecutar el target.     | `bool`         | `false`              |
| `run`            | Configuración para el target de tipo run (opcional).                | `object`       | `null`               |
| `gke`            | Configuración para el target de tipo GKE (opcional).                | `object`       | `null`               |
| `labels`         | Etiquetas asociadas al target.                                      | `map(string)`  | `{}`                 |

#### Subvariables de `run` y `gke`:

- **run**: Configuración de tipo run para un target.
    - `location`: Ubicación donde se ejecuta el run.

- **gke**: Configuración de tipo GKE para un target.
    - `cluster`: Nombre del clúster GKE.
    - `internal_ip`: Si se requiere una IP interna para el clúster GKE (opcional).

### `gcp_cloud_deploy_pipelines` (list)

Configuración para los delivery pipelines de Cloud Deploy. Define la lista de pipelines, con sus respectivas configuraciones.

| Nombre           | Descripción                                                        | Tipo           | Valor Predeterminado |
|------------------|--------------------------------------------------------------------|----------------|----------------------|
| `location`       | Ubicación del pipeline.                                            | `string`       | N/A                  |
| `name`           | Nombre del pipeline.                                               | `string`       | N/A                  |
| `description`    | Descripción del pipeline (opcional).                               | `string`       | `"A description of the delivery pipeline."` |
| `target_id`      | ID del target asociado al pipeline.                                | `string`       | N/A                  |
| `annotations`    | Anotaciones asociadas al pipeline.                                 | `map(string)`  | `{}`                 |
| `labels`         | Etiquetas asociadas al pipeline.                                   | `map(string)`  | `{}`                 |

## Salidas

Este módulo define las siguientes salidas:

### `cloud_deploy_targets`

Información de los targets creados.

```h
output "cloud_deploy_targets" {
  description = "Información de los targets creados."
  value       = google_clouddeploy_target.targets
}
```
### pipeline_names

Lista de los nombres de los delivery pipelines creados.

```h
output "pipeline_names" {
  description = "Los nombres de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.name]
}
```

### pipeline_ids

Lista de los IDs de los delivery pipelines creados.

```h
output "pipeline_ids" {
  description = "Los IDs de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.id]
}
```

### pipeline_locations

Lista de las ubicaciones de los delivery pipelines creados.

```h
output "pipeline_locations" {
  description = "Las ubicaciones de los delivery pipelines."
  value       = [for pipeline in google_clouddeploy_delivery_pipeline.this : pipeline.location]
}
```

## Ejemplo de Uso

Este es un ejemplo de cómo usar el módulo para crear targets y delivery pipelines en tu proyecto de GCP:

1. Ejemplo con un solo pipeline y un target

```h
module "cloud-deploy" {
  source  = "evilDr4gon/cloud-deploy/google"
  version = "1.0.0"

  project_id = "mi-proyecto-gcp"

  gcp_cloud_deploy_targets = [
    {
      name             = "target-1"
      location         = "us-east1"
      require_approval = false

      run = {
        location = "projects/<project-id>/locations/<region>"
      }
    }
  ]

  gcp_cloud_deploy_pipelines = [
    {
      name        = "pipeline-1"
      location    = "us-central1"
      target_id   = "target-1"
      annotations = { "note" = "Pipeline de despliegue" }
      labels      = { "env" = "prod" }
    }
  ]
}

```

Este ejemplo crea un target y un pipeline, asignando el target-1 al pipeline-1.

2. Ejemplo con múltiples pipelines y targets

```h
module "cloud-deploy" {
  source  = "evilDr4gon/cloud-deploy/google"
  version = "1.0.0"

  project_id = "mi-proyecto-gcp"

  gcp_cloud_deploy_targets = [
    {
      name             = "target-1"
      location         = "us-east1"
      require_approval = false

      run = {
        location = "projects/<project-id>/locations/<region>"
      }
    },

    {
      name             = "target-2"
      location         = "us-east1"
      require_approval = false

      gke = {
        cluster = "projects/<project-id>/locations/<region&zone>/clusters/<cluster-name>"
      }
    }
  ]

  gcp_cloud_deploy_pipelines = [
    {
      name        = "pipeline-1"
      location    = "us-east1"
      target_id   = "target-1"
      annotations = { "note" = "Pipeline de despliegue 1" }
      labels      = { "env" = "dev" }
    },
    {
      name        = "pipeline-2"
      location    = "us-east1"
      target_id   = "target-2"
      annotations = { "note" = "Pipeline de despliegue 2" }
      labels      = { "env" = "prod" }
    }
  ]
}
```

Este ejemplo crea dos targets y dos pipelines, asignando un target a cada pipeline.

## Autor

Este módulo fue desarrollado por Jose Reynoso.
