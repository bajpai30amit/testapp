variable "gcp_credentials" {
    type = string
    description = "Location of file"
}
variable "gcp_project_id" {
    type = string
    description = "GCP Project ID"
}
variable "gcp_region" {
    type = string
    description = "GCP Region"
}
variable "gcp_zones" {
    type = list(string)
    description = "GCP zones list"
}
variable "gcp_network" {
    type = string
    description = "VPC Network name"
}
variable "gcp_subnetwork" {
    type = string
    description = "VPC SubNetwork name"
}
variable "gcp_service_account" {
    type = string
    description = "GCP Service account"
}
