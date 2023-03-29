resource "azurerm_resource_group" "main" {
  name     = var.md_metadata.name_prefix
  location = var.azure_storage_account_data_lake.specs.azure.region
  tags     = var.md_metadata.default_tags
}

resource "azurerm_eventhub_namespace" "main" {
  name                     = var.md_metadata.name_prefix
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  sku                      = var.hub.sku
  auto_inflate_enabled     = var.hub.enable_auto_inflate
  capacity                 = var.hub.enable_auto_inflate ? null : var.hub.throughput_units
  maximum_throughput_units = var.hub.enable_auto_inflate ? var.hub.max_throughput_units : null
  zone_redundant           = var.hub.zone_redundant
  minimum_tls_version      = "1.2"
  tags                     = var.md_metadata.default_tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_eventhub" "main" {
  name                = var.md_metadata.name_prefix
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  partition_count     = var.hub.partition_count
  message_retention   = var.hub.message_retention

  capture_description {
    enabled             = true
    encoding            = var.capture.arvo_encoding
    interval_in_seconds = var.capture.capture_interval
    size_limit_in_bytes = var.capture.capture_buildup
    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = "${var.md_metadata.name_prefix}-eventhub-capture"
      storage_account_id  = var.azure_storage_account_data_lake.data.infrastructure.ari
    }
  }
}
