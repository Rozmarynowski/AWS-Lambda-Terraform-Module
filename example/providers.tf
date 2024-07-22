provider "aws" {
  region  = "eu-central-1"
  profile = terraform.workspace

  default_tags {
    tags = {
      application      = local.general.application
      creator          = "adam.rozmarynowski"
      environment      = local.general.environment
      managed_by       = "terraform"
    }
  }
}
