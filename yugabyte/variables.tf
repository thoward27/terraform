
variable "allowed_sources" {
  description = "Add Source IP in Security Group to restrict the traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "associate_public_ip_address" {
  description = "Associate public IP address to instances created."
  default     = true
  type        = string
}

variable "aws_region" {
  description = "Region name for AWS. Example: 'us-west-2'"
  default     = "us-east-1"
  type        = string
}

variable "aws_availability_zones" {
  type = map(list(string))
  default = {
    "ap-northeast-1" = ["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"],
    "ap-northeast-2" = ["ap-northeast-2a", "ap-northeast-2c"],
    "ap-south-1"     = ["ap-south-1a", "ap-south-1b"],
    "ap-southeast-1" = ["ap-southeast-1a", "ap-southeast-1b"],
    "ap-southeast-2" = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"],
    "ca-central-1"   = ["ca-central-1a", "ca-central-1b"],
    "eu-central-1"   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"],
    "eu-west-1"      = ["eu-west-1a", "eu-west-1b"],
    "eu-west-2"      = ["eu-west-2a", "eu-west-2b"],
    "sa-east-1"      = ["sa-east-1a", "sa-east-1b", "sa-east-1c"],
    "us-east-1"      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"],
    "us-east-2"      = ["us-east-2a", "us-east-2b", "us-east-2c"],
    "us-west-1"      = ["us-west-1a", "us-west-1b"],
    "us-west-2"      = ["us-west-2a", "us-west-2b", "us-west-2c"],
  }
}

variable "cluster_name" {
  description = "The name for the cluster (universe) being created."
  default     = "prod_db1_use1"
  type        = string
}

variable "instance_type" {
  description = "The type of instances to create."
  default     = "t3.medium"
  type        = string
}

variable "num_instances" {
  description = "Number of instances in the YugaByte cluster."
  default     = "3"
  type        = string
}

variable "replication_factor" {
  description = "The replication factor for the universe."
  default     = 3
  type        = string
}

variable "root_volume_size" {
  description = "The volume size in gigabytes."
  default     = "50"
  type        = string
}

variable "ssh_user" {
  description = "The public key to use when connecting to the instances."
  type        = string
  default     = "centos"
}

variable "ssh_private_key" {
  description = "Base64 encoded SSH Private key."
  type        = string
}

variable "use_public_ip_for_ssh" {
  description = "Flag to control use of public or private ips for ssh."
  default     = "true"
  type        = string
}

variable "yb_download_url" {
  description = "The download location of the YugaByteDB edition"
  default     = "https://downloads.yugabyte.com"
  type        = string
}

variable "yb_version" {
  description = "The version number of YugaByteDB to install"
  default     = "2.13.2.0"
  type        = string
}

