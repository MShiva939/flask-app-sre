#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1
REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/devops-app
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI
docker stop my-app || true
docker rm my-app || true
docker run -d -p 80:80 --name my-app $REPOSITORY_URI:latest

