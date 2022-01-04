module "platform" {
  source = "git@github.com:rbilabs/ctg-devops//modules/platform"
}

locals {
  account_id   = module.platform.account_id
  partition    = module.platform.partition
  region       = module.platform.region
  region_short = module.platform.region_short

  common_tags = {
    "Service" = "rbi"
    "Stage"   = var.stage
    "Source"  = "Terraform"
    "Module"  = "ctg-template-service"
    "Region"  = local.region

    "rbi:brand" = var.brand
    "rbi:stage" = var.stage
    "rbi:name"  = "template-service"
  }
}
