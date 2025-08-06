#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1
docker stop myapp || true
docker rm myapp || true
docker run -d -p 80:80 --name myapp $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/devops-app:latest
