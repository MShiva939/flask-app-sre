
# APPLICATION CODE REPOSITORY DOCUMENTATION


# OVERVIEW

This repository contains the application code and deployment scripts 
for automated Docker image creation, push to AWS ECR, and deployment 
using AWS CodeBuild and CodeDeploy.

CodeBuild uses`buildspec.yml` to build the Docker image from `Dockerfile`
and push it to the ECR repository.

CodeDeploy uses `appspec.yml` to execute deployment scripts from the 
`scripts/` directory. The deployment process stops the running container, 
pulls the latest image, and starts a new container. Health checks ensure 
that the new container is running successfully.


# CODEBUILD WORKFLOW (buildspec.yml)

1. Install dependencies.
2. Authenticate to AWS ECR.
3. Build Docker image using `Dockerfile`.
4. Tag image with commit hash or build ID.
5. Push image to AWS ECR repository.

# CODEDEPLOY WORKFLOW (appspec.yml)

1. Download latest application package.
2. Run `start_server.sh` to:
   - Stop existing container.
   - Pull latest image from ECR.
   - Start new container with updated code.
3. Run `health_check.sh` to:
   - Verify if the new container is healthy.
   - Fail deployment if health check fails.

# DEPLOYMENT SCRIPTS

scripts/start_server.sh:
- Stops any running container named "my-app".
- Pulls the latest Docker image from AWS ECR.
- Runs the new container in detached mode.

scripts/health_check.sh:
- Uses `docker ps` or container logs to check status.
- Returns 0 if running, 1 if stopped.

# ROLLBACK APPROACH

Automatic rollback via CodeDeploy
 If health_check.sh fails, CodeDeploy reverts to last successful Docker image.

 Manual rollback steps:
 1. Go to CodeDeploy deployment group in AWS Console
 2. Find last successful deployment revision
 3. Redeploy that revision to restore stable state

 Image tagging:
 All images in ECR tagged with commit hash and 'latest'
 Pull commit-specific tag of last successful build for rollback

 Monitoring after rollback:
 CloudWatch alarms (EC2 health, ALB 5xx) stay active
 SNS topic sends email alerts if issues persist

# SECURITY BEST PRACTICES
- Use least privilege IAM roles for CodeBuild and CodeDeploy by granting only the specific permissions required for the tasks, and avoid attaching unused permissions.
- Restrict access to the ECR repository.
- Enable CloudWatch Logs for build and deployment monitoring.

# OBSERVABILITY
- CloudWatch Logs integrated with CodeBuild and CodeDeploy.
- CloudWatch Alarm: EC2 Health Check
 -> Triggers if EC2 instance status check fails
- CloudWatch Alarm: ALB 5xx Errors
 -> Triggers if ALB returns high number of 5xx responses
- Both alarms are linked to a single Amazon SNS topic
 -> Sends email alerts to subscribers in case of alarm
  

# NOTES
- Ensure Docker is installed and configured in CodeBuild environment.
- Test scripts locally before committing to repository.

