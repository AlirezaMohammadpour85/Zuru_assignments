resource "aws_ecr_repository" "go_api_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# modified to use one ecr, different tags for different images 
# remove next section to have two different ecrs for go-api and nginx-proxy
# resource "aws_ecr_repository" "nginx_proxy" {
#   name                 = var.ecr_repo_name_nginx_proxy
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

