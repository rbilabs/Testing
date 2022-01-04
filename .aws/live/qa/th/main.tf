provider "aws" {
  allowed_account_ids = ["599690419085"]
  region              = "us-east-1"
}

provider "aws" {
  allowed_account_ids = ["599690419085"]
  alias               = "use1"
  region              = "us-east-1"
}

provider "aws" {
  allowed_account_ids = ["599690419085"]
  alias               = "euc1"
  region              = "eu-central-1"
}

terraform {
  backend "remote" {
    hostname     = "tfe.infra.rbi.tools"
    organization = "rbitech"

    workspaces {
      name = "rbi-ctg-qa-th-template"
    }
  }
}

module "service" {
  source = "../../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "th"

  stage = "qa"
}
