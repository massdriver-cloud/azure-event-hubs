// Auto-generated variable declarations from massdriver.yaml
variable "azure_service_principal" {
  type = object({
    data = object({
      client_id       = string
      client_secret   = string
      subscription_id = string
      tenant_id       = string
    })
    specs = object({})
  })
}
variable "azure_storage_account_data_lake" {
  type = object({
    data = object({
      infrastructure = object({
        ari      = string
        endpoint = string
      })
      security = object({
        iam = optional(map(object({
          role  = any
          scope = string
        })))
      })
    })
    specs = object({
      azure = optional(object({
        region = string
      }))
    })
  })
}
variable "capture" {
  type = object({
    arvo_encoding    = string
    capture_buildup  = number
    capture_interval = number
  })
}
variable "hub" {
  type = object({
    message_retention   = number
    partition_count     = number
    sku                 = string
    throughput_units    = number
    zone_redundant      = bool
    enable_auto_inflate = optional(bool)
  })
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "monitoring" {
  type = object({
    mode = optional(string)
    alarms = optional(object({
      cpu_metric_alert = optional(object({
        aggregation = string
        frequency   = string
        operator    = string
        severity    = number
        threshold   = number
        window_size = string
      }))
      memory_metric_alert = optional(object({
        aggregation = string
        frequency   = string
        operator    = string
        severity    = number
        threshold   = number
        window_size = string
      }))
      server_errors_metric_alert = optional(object({
        aggregation = string
        frequency   = string
        operator    = string
        severity    = number
        threshold   = number
        window_size = string
      }))
    }))
  })
}