locals {
  capture = {
    # converts MiB to bytes
    build_up = var.capture.capture_buildup * 1024 * 1024
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.md_metadata.name_prefix
  location = var.azure_storage_account_data_lake.specs.azure.region
  tags     = var.md_metadata.default_tags
}

resource "azurerm_eventhub_namespace" "main" {
  name                         = var.md_metadata.name_prefix
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  sku                          = var.hub.sku
  auto_inflate_enabled         = var.hub.sku == "Standard" ? var.hub.enable_auto_inflate : false
  capacity                     = try(var.hub.enable_auto_inflate ? null : var.hub.throughput_units, null)
  maximum_throughput_units     = try(var.hub.enable_auto_inflate ? var.hub.throughput_units : null, null)
  zone_redundant               = var.hub.zone_redundant
  minimum_tls_version          = "1.2"
  local_authentication_enabled = false
  tags                         = var.md_metadata.default_tags

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
    size_limit_in_bytes = local.capture.build_up
    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = "${var.md_metadata.name_prefix}-eventhub-capture"
      storage_account_id  = var.azure_storage_account_data_lake.data.infrastructure.ari
    }
  }
}
