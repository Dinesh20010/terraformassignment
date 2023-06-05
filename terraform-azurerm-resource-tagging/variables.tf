variable "resource_group_name" {
  type = string
  default = ""
  description = "(OPTIONAL) Name of an existing Azure resource group from which to fetch the tags"
}

variable "subscription_id" {
  type = string
  default = ""
  description = "(OPTIONAL) ID of an Azure subscription from which to fetch the tags. if not provided, then uses current Azure Subscription"
}

variable "additional_tags" {
  type = map(string)
  default = {}
  description = "(OPTIONAL) Map of additional tags to be appended to the tags from the azure subscription or resource group"
}

variable "only_mandatory_tags" {
  type = bool
  default = true
  description = "(OPTIONAL) If true then return the mandatory XYZ tags, if false then return all tags. Defaults to true"
}

variable "mandatory_tag_keys" {
  type = list(string)
  default = ["billingReference", "cmdbReference", "opEnvironment", "hostingRestrictions"]
  description = "(OPTIONAL) List of tag keys to filter - defaults to the mandatory tag keys, [\"billingReference\", \"cmdbReference\", \"opEnvironment\", \"hostingRestrictions\"], but can be overrided with other values and subset of values."
}