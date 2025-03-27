# Zuru_assignments
Zuru assignements

# API app
 I created a folder for the first exercise and used similar configurations to install the local app using Docker Compose.
 
- The root folder contains a docker-compose.yml file, which is used for step 3 of the exercise and for generating the application.

- Docker and Docker-Compose both can be used to extract the image IDs (so I put it there), and then the application can be tested by tagging and uploading the images to the ECR repository.

- I created a separate Terraform file for each service to simplify the configuration. All files are located in the root folder, which I believe is sufficient for this small application.

- The Terraform configuration and API application have been tested and function properly.


# ECR considerations
There are two primary approaches for managing images in Elastic Container Registry (ECR), depending on organizational policies:

1. *Single Repository with Tagging:* Create one ECR repository and utilize tags and versioning to distinguish between different images.

2. *Dedicated Repository per Image:* Create a separate ECR repository for each distinct image.

For this implementation, I opted for the first approach, creating a single repository and managing images within it using distinct tags.

# ECS Considerations
The scenario can be implemented using either EC2 or Fargate launch types. I chose Fargate for its serverless architecture.


## Some notes on CI/CD

* A single ECS task definition was used, encompassing two containers. To enhance availability, these containers were deployed across two separate subnets.
* An Ubuntu virtual machine was employed on my local machine for development and testing. To enable the use of Bash, the shell executor was selected. Consequently, the `/home/gitlab-runner/.bash_logout` file required modification. Specifically, the following lines, as referenced in the GitLab Runner shell profile loading documentation, were commented out:

    ```bash
    if [ "$SHLVL" = 1 ]; then
        [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
    fi
    ```

## GitLab Runner Sudoers Configuration

To allow the GitLab Runner user to execute commands with `sudo` without requiring a password, the following line was added to the `/etc/sudoers` file using `sudo visudo`:

```bash
gitlab-runner ALL=(ALL) NOPASSWD:ALL


## Defined vars in gitlab 
1. AWS_ACCESS_KEY_ID
2. AWS_ACCOUNT_ID
3. AWS_DEFAULT_REGION
4. AWS_SECRET_ACCESS_KEY

