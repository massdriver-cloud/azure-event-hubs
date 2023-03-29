locals {
  automated_alarms = {
    cpu_metric_alert = {
      severity    = "1"
      frequency   = "PT1M"
      window_size = "PT5M"
      operator    = "GreaterThan"
      aggregation = "Average"
      threshold   = 90
    }
    memory_metric_alert = {
      severity    = "1"
      frequency   = "PT1M"
      window_size = "PT5M"
      operator    = "GreaterThan"
      aggregation = "Average"
      threshold   = 90
    }
    server_errors_metric_alert = {
      severity    = "1"
      frequency   = "PT5M"
      window_size = "PT5M"
      operator    = "GreaterThan"
      aggregation = "Average"
      threshold   = 5
    }
  }
  alarms_map = {
    "AUTOMATED" = local.automated_alarms
    "DISABLED"  = {}
    "CUSTOM"    = lookup(var.monitoring, "alarms", {})
  }
  alarms             = lookup(local.alarms_map, var.monitoring.mode, {})
  monitoring_enabled = var.monitoring.mode != "DISABLED" ? 1 : 0
}

module "alarm_channel" {
  source              = "github.com/massdriver-cloud/terraform-modules//azure/alarm-channel?ref=e9fbd67"
  md_metadata         = var.md_metadata
  resource_group_name = azurerm_resource_group.main.name
}

module "cpu_metric_alert" {
  count                   = local.monitoring_enabled
  source                  = "github.com/massdriver-cloud/terraform-modules//azure/monitor-metrics-alarm?ref=e9fbd67"
  scopes                  = [azurerm_eventhub_namespace.main.id]
  resource_group_name     = azurerm_resource_group.main.name
  monitor_action_group_id = module.alarm_channel.id
  severity                = local.alarms.cpu_metric_alert.severity
  frequency               = local.alarms.cpu_metric_alert.frequency
  window_size             = local.alarms.cpu_metric_alert.window_size

  depends_on = [
    azurerm_eventhub_namespace.main
  ]

  md_metadata  = var.md_metadata
  display_name = "CPU Usage"
  message      = "High CPU Usage"

  alarm_name       = "${var.md_metadata.name_prefix}-highProcessorTime"
  operator         = local.alarms.cpu_metric_alert.operator
  metric_name      = "NamespaceCpuUsage"
  metric_namespace = "microsoft.eventhub/namespaces"
  aggregation      = local.alarms.cpu_metric_alert.aggregation
  threshold        = local.alarms.cpu_metric_alert.threshold
}

module "memory_metric_alert" {
  count                   = local.monitoring_enabled
  source                  = "github.com/massdriver-cloud/terraform-modules//azure/monitor-metrics-alarm?ref=e9fbd67"
  scopes                  = [azurerm_eventhub_namespace.main.id]
  resource_group_name     = azurerm_resource_group.main.name
  monitor_action_group_id = module.alarm_channel.id
  severity                = local.alarms.memory_metric_alert.severity
  frequency               = local.alarms.memory_metric_alert.frequency
  window_size             = local.alarms.memory_metric_alert.window_size

  depends_on = [
    azurerm_eventhub_namespace.main
  ]

  md_metadata  = var.md_metadata
  display_name = "Memory Usage"
  message      = "High Memory Usage"

  alarm_name       = "${var.md_metadata.name_prefix}-highMemoryUsage"
  operator         = local.alarms.memory_metric_alert.operator
  metric_name      = "NamespaceMemoryUsage"
  metric_namespace = "microsoft.eventhub/namespaces"
  aggregation      = local.alarms.memory_metric_alert.aggregation
  threshold        = local.alarms.memory_metric_alert.threshold
}

module "server_errors_metric_alert" {
  count                   = local.monitoring_enabled
  source                  = "github.com/massdriver-cloud/terraform-modules//azure/monitor-metrics-alarm?ref=e9fbd67"
  scopes                  = [azurerm_eventhub_namespace.main.id]
  resource_group_name     = azurerm_resource_group.main.name
  monitor_action_group_id = module.alarm_channel.id
  severity                = local.alarms.memory_metric_alert.severity
  frequency               = local.alarms.memory_metric_alert.frequency
  window_size             = local.alarms.memory_metric_alert.window_size

  depends_on = [
    azurerm_eventhub_namespace.main
  ]

  md_metadata  = var.md_metadata
  display_name = "Server Errors"
  message      = "High Server Errors"

  alarm_name       = "${var.md_metadata.name_prefix}-highServerErrors"
  operator         = local.alarms.memory_metric_alert.operator
  metric_name      = "ServerErrors"
  metric_namespace = "microsoft.eventhub/namespaces"
  aggregation      = local.alarms.memory_metric_alert.aggregation
  threshold        = local.alarms.memory_metric_alert.threshold
}
