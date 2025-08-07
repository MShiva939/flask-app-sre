#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1
docker stop my-app || true
docker rm my-app || true
docker run -d -p 80:80 --name my-app $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/devops-app:latest

