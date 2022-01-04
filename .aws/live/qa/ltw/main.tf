provider "aws" {
  allowed_account_ids = ["295006134468"]
  region              = "us-east-1"
}

provider "aws" {
  allowed_account_ids = ["295006134468"]
  alias               = "use1"
  region              = "us-east-1"
}

terraform {
  backend "remote" {
    hostname     = "tfe.infra.rbi.tools"
    organization = "rbitech"

    workspaces {
      name = "rbi-ctg-qa-ltw-template"
    }
  }
}

module "service" {
  source = "../../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "ltw"

  stage = "qa"
}
