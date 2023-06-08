**Terraform Module - PostgreSQL**

**Requirements**

This module has been certified with the below set of provider versions.

Please ensure you are using the below listed versions to rule out any provider related issues.

| Name      | Version |

\|-----------|---------|

| terraform | 1.3.0   |

| azurerm   | 3.29.0  |

| random    | 3.4.4   |

Azurerm 3.29.0 or newer is needed because previous versions had errors that prevented from creating a replica. First error and second error.

If you are using more than one module from registry, it will automatically use the latest provider version held within the module. in case of inoperability with the multiple provider versions.

**About**

This module creates Postgres SQL server (optionally) and databases (0 or more). Created postgres should not require further changes to be compliant for XYZ usage. It basically enforces TLS with version>=1.2, disables public access and adds both private endpoint and customer-managed key (CMK).

The definition of the input variables, output attributes and the resource definition are located at the root of the repository.

The Implementation is based on official Azure RM terraform resources – azurerm\_postgresql\_server and azurerm\_postgresql\_database.

References:

- [azurerm_postgresql_server Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server)
- [azurerm_postgresql_database Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database)

**Examples**

There are a few examples on how to use this module. Here’s the general snippet but you can get into details in examples subdirectory. Those examples are described in details in this chapter. Be aware that you need to create resource group yourself, this module doesn’t create one.

\# create postgresql server
module "postgres" {
`  `source = "../terraform/terraform-azurerm-postgresql"
`  `version = "1.0.2"

`  `xyz\_net\_resource\_group\_name = var.xyz\_net\_resource\_group\_name
`  `xyz\_vnet\_name = var.xyz\_vnet\_name
`  `db\_subnet\_name = var.db\_subnet\_name
`  `location = var.location
`  `resource\_group\_name = azurerm\_resource\_group.rg.name
`  `environment\_name = var.environment\_name

`  `tags = module.tagging.subscription\_tags

`  `# server Parameters
`  `create\_server = true
`  `server\_name = var.server\_name
`  `server\_version = var.server\_version
`  `sku\_name = var.sku\_name
`  `storage\_size = var.storage\_size
`  `encryption\_enabled = var.encryption\_enabled
`  `backup\_retention\_days = var.backup\_retention\_days
`  `geo\_redundant\_backup\_enabled = var.geo\_redundant\_backup\_enabled
`  `create\_mode = var.create\_mode
`  `auto\_grow\_enabled = var.auto\_grow\_enabled

`  `# database parameters
`  `databases\_config = var.databases\_config

`  `# customer-managed key
`  `key\_vault\_name = var.key\_vault\_name
`  `key\_vault\_resource\_group = var.key\_vault\_resource\_group
`  `encryption\_key\_name = var.encryption\_key\_name

}

This results with a Postgres server with <server\_name>-<environment\_name> name and a database with <database\_name>-<environment\_name>.

**Basic database and server**

examples/basic shows the most common scenario of creating a server with one database. There’s no replica involved. You need to pass a name of already existing resource group, keyvault key, VNET and subnet in that scenario. Inputs describes those parameters in details.



**Server without database**

examples/server\_only shows a scenario of creating a server without any database. This may be used in a case where you’re creating just a replica. You need to pass a Name of already existing resource group, keyvault key, VNET and subnet in that scenario. Inputs describes those parameters in details.

**Database without server**

examples/db\_only shows a scenario of creating a database without a server. This may be used in a case where server is managed by another process. You need to pass a name of already existing resource group, keyvault key, VNET and subnet in that scenario. Inputs describes those parameters in details.

**Server plus replica**

examples/server\_plus\_replica shows a scenario of creating a server with a database and another server configured as replica. You need to pass a name of already existing resource groups, keyvault key, VNET and subnet in that scenario. Inputs describes those parameters in details.

**Resources**

|**Name**|**Type**|
| :- | :- |
|azurerm\_key\_vault\_access\_policy.postgres\_server\_kv\_policy|Resource|
|Azurerm\_postgresql\_database.postgres\_databases|Resource|
|Azurerm\_postgresql\_server.postgres\_server|Resource|
|Azurerm\_postgresql\_server\_key.postgres\_cmk|Resource|
|Azurerm\_private\_endpoint.postgres\_privateendpoint|Resource|
|Random\_password.random\_password|Resource|
|Random\_string.random\_string|Resource|
|Azurerm\_key\_vault.vault|Data source|
|Azurerm\_key\_vault\_key.encryption\_key|Data source|
|Azurerm\_subnet.xyz\_subnet|Data source|
|Azurerm\_key\_vault\_secret.key\_vault\_password|Resource|











**Inputs**

The following table explains the full list of input variables required by this module.

The definition of these variables is in the variables.tf file.

|**Name**|**Description**|
| :- | :- |
|<a name="auto_grow_enabled"></a>[auto_grow_enabled](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#auto_grow_enabled)|Storage auto-grow prevents your server from running out of storage|
|<a name="backup_retention_days"></a>[backup_retention_days](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#backup_retention_days)|Backup retention days for the server, supported values are between 7 and 35 days.|
|<a name="create_mode"></a>[create_mode](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#create_mode)|The creation mode. Can be used to restore or replicate existing servers. Possible values are PointInTimeRestore|
|create\_server|True if server has to be created. False if it already exists.|
|databases\_config|Map of objects with parameters for Postgres Database. If empty, no database will be created.|
|<a name="sku_name"></a>[sku_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#sku_name)|The name of the SKU used by the server. By default: GP\_Gen5\_2.|
|<a name="version"></a>[version](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#version)|Server version.|
|`  `encryption\_enabled|<p>Enabling encryption on the server level is not recommended. It causes substantial performance degradation and is not supported by Microsoft. More Infor: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#infrastructure_encryption_enabled></p><p></p>|
|encryption\_key\_name|The Name of the Customer Managed Key which should be used to encrypt this postgres.|
|Environment\_name|Logical environment name within your subscription.|
|<a name="geo_redundant_backup_enabled"></a>[geo_redundant_backup_enabled](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#geo_redundant_backup_enabled)|This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. |
|key\_vault\_name|Name of the azure Keyvault containing the Customer Managed key|
|key\_vault\_resource\_group|Name of the resource group to create and place your resources in.|
|`  `server\_name|Server name without an environment suffix, eg. Postgresql-srv01|
|source\_server\_id|For creation modes other than Default, the source server ID to use.|
|<a name="storage_mb"></a>[storage_mb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#storage_mb)|Storage size, in megabytes, of the Azure Database for PostgreSQL server.|
|tags|Optional map of strings to be used as Azure Tags for all resources.|
|Threat\_detection\_policy|Threat detection policy settings for server.|
|xyz\_net\_resource\_group\_name|Resource group containing the XYZ networking resources.|
|xyz\_subnet\_name|XYZ subnet name.|
|xyz\_vnet\_name|XYZ virtual network name.|






