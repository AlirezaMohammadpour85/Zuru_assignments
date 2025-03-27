# Zuru_assignments
Zuru assignements

# API app
I created a folder for first exercise and almost the same configurations for installing local app using docker compose
- In the root folder there is a docker-compose.yml file which is used for step3 of exercise and generationg.
- One can use docker compose to extract the images ids and then test the app by tagging and uploading the image to the ECR repository.
- I created a different tf file for each service needs to be created for simplicity, all are in the root folder which I think enough for this small app.

- The terrafomr and api app has been tested and work properly.


# ECR considerations
For this request there are two different approach depending on the company  policies.
1. Create one Repository and create images inside that repository using tags+version
2. create a Repository for each image

I used the first approach and create one repository and add images to that repository with different tags.

# ECS Considerations
we can apply the scenario using EC2 or FARGATE. I chose FARGATE.

## Some notes on CI/CD

- I used a sigle ecs task with two containers. I dedicated two different subnets for availability.
- I used ubuntu_vm machine in my pc. To be able to use bash - i selected shell as executer and I had to condifgire the *"/home/gitlab-runner/.bash_logout"*  file as follow:

I need to comment these lines https://docs.gitlab.com/runner/shells/#shell-profile-loading:
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi 

- need to add gitlabrunner into the sudoers withou requesting passwod
sudo visudo
gitlab-runner ALL=(ALL) NOPASSWD:ALL

## Defined vars in gitlab 
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID
AWS_DEFAULT_REGION
AWS_SECRET_ACCESS_KEY

