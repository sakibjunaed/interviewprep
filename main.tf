terraform {
    backend "s3" {
        bucket = "sakib-terraform-state-9647"
        key = "global/s3/terraform.tfstate"
        region = "us-east-1"
    }
}