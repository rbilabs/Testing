provider "aws" {
  allowed_account_ids = ["208920643775"]
  region              = "us-east-1"
}

provider "aws" {
  allowed_account_ids = ["208920643775"]
  alias               = "use1"
  region              = "us-east-1"
}

provider "aws" {
  allowed_account_ids = ["208920643775"]
  alias               = "euc1"
  region              = "eu-central-1"
}

terraform {
  backend "remote" {
    hostname     = "tfe.infra.rbi.tools"
    organization = "rbitech"

    workspaces {
      name = "rbi-ctg-staging-template"
    }
  }
}

module "service_bk" {
  source = "../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "bk"

  stage = "staging"
}

module "service_plk" {
  source = "../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "plk"

  stage = "staging"
}

module "service_th" {
  source = "../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "th"

  stage = "staging"
}

module "service_ltw" {
  source = "../../modules/service"

  providers = {
    aws = aws.use1
  }

  brand = "ltw"

  stage = "staging"
}
