terraform { 
   required_providers { 
      aws = { 
         source = "hashicorp/aws" 
         version = "~> 5.0" 
      } 
      docker = { 
         source = "kreuzwerker/docker" 
         version = "3.0.2" 
      } 
   } 
} 
 
provider "aws" { 
   region = "us-east-1" 
   shared_credentials_files = ["./credentials"] 
}

provider "docker" { 
   registry_auth { 
      address = data.aws_ecr_authorization_token.ecr_token.proxy_endpoint 
      username = data.aws_ecr_authorization_token.ecr_token.user_name 
      password = data.aws_ecr_authorization_token.ecr_token.password 
   } 
}

locals { 
   image = "ghcr.io/csse6400/taskoverflow:latest" 
   database_username = "administrator" 
   database_password = "foobarbaz" # this is bad 
} 

data "aws_iam_role" "lab" { 
   name = "LabRole" 
} 
 
data "aws_vpc" "default" { 
   default = true 
} 
 
data "aws_subnets" "private" { 
   filter { 
      name = "vpc-id" 
      values = [data.aws_vpc.default.id] 
   } 
}

data "aws_ecr_authorization_token" "ecr_token" {} 

resource "local_file" "url" {
    content  = aws_lb.taskoverflow.dns_name # replace this with a URL from your terraform
    filename = "./api.txt"
}
