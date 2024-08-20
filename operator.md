## Azure Event Hubs

Azure Event Hubs is a fully managed, real-time data ingestion service that streamlines the process of collecting, transforming, and storing massive data sets. It is designed to handle millions of events per second, making it a suitable solution for big data and analytics pipelines.

### Design Decisions

The design of the Azure Event Hubs management implementation includes several key elements to ensure efficient operation and ease of use:

- **Resource Group:** A new Resource Group is created to host the Event Hub Namespace and related resources. The `azurerm_resource_group` resource is used for this purpose.
- **Event Hub Namespace:** The `azurerm_eventhub_namespace` resource manages the Event Hub Namespace. Auto-inflate, capacity planning, and other properties are configured based on the module's input variables.
- **Event Hub Instance:** The `azurerm_eventhub` resource configures the specifics of the Event Hub, including partition count, message retention, and capture description.
- **Monitoring and Alarms:** Automated alarms for CPU usage, memory usage, and server errors are set up using modules to ensure the availability and health of the Event Hub Namespace.

### Runbook

#### Unable to Connect to Azure Event Hubs

If you are experiencing connectivity issues, use the following Azure CLI command to check the status of your Event Hub Namespace:

```sh
az eventhubs namespace show --name <your-namespace-name> --resource-group <your-resource-group-name>
```

You should see details about your Event Hub Namespace's status. Ensure that it is in the "Active" state.

#### Event Hub Namespace Reaches Throughput Limit

When your Event Hub Namespace reaches its throughput limit, you might need to upgrade the capacity or enable auto-inflate. Verify the current settings with:

```sh
az eventhubs namespace show --name <your-namespace-name> --resource-group <your-resource-group-name>
```

Look for the `sku` and `maximumThroughputUnits` properties. If necessary, upgrade by:

```sh
az eventhubs namespace update --name <your-namespace-name> --resource-group <your-resource-group-name> --sku <new-sku> --maximum-throughput-units <desired-units>
```

#### High CPU or Memory Usage Alerts

To troubleshoot high CPU or memory usage, you can inspect the metrics available for your Event Hub Namespace:

```sh
az monitor metrics list --resource <your-namespace-resource-id> --metric NamespaceCpuUsage NamespaceMemoryUsage --interval PT1M --aggregation Average
```

Check the reported values to identify any anomalies.

#### Event Hub Capture Issues

If data capture isn't working as expected, check the storage account settings and capture configuration:

```sh
az eventhubs eventhub show --name <your-eventhub-name> --namespace-name <your-namespace-name> --resource-group <your-resource-group-name>
```

Review the `captureDescription` section, ensuring the storage account is correctly referenced and the capture settings align with your requirements.

If issues persist, verify the storage account accessibility:

```sh
az storage account show --name <your-storage-account-name> --resource-group <your-resource-group-name>
```

Ensure the storage account is active and accessible.

#### Monitoring and Alerts Configuration

If alerts are not functioning, verify the Action Group configuration and metric alert settings. List your action groups to ensure they are properly set up:

```sh
az monitor action-group list --resource-group <your-resource-group-name>
```

Ensure the alerts are targeting the correct Action Group and the configuration aligns with the defined policies:

```sh
az monitor metrics alert list --resource-group <your-resource-group-name>
```

Double-check each alert's `criteria` and `scopes` properties.

