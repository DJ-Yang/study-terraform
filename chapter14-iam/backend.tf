terraform {
	backend "s3" {
		bucket	= "tf101-jupiter-apne2-tfstate-dj"
		key 	= "terraform-study/chapter14-iam/terraform.tfstate"
		region 	= "ap-northeast-2"
		encrypt = true
		dynamodb_table = "terraform-lock"
	}
}
