
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::128840427886:role/OrganizationAccountAccessRole"
  }
}
