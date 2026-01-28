#!/bin/bash

# Deployment script for Full Stack Docker Application
echo "🚀 Starting deployment process..."

# Variables - CHANGE THESE TO YOUR DOCKER HUB USERNAME
DOCKER_USERNAME="your-dockerhub-username"
VERSION="v1.0"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📦 Building Docker images...${NC}"

# Build frontend
echo "Building frontend..."
docker build -t ${DOCKER_USERNAME}/nodejs-frontend:${VERSION} ./frontend
docker tag ${DOCKER_USERNAME}/nodejs-frontend:${VERSION} ${DOCKER_USERNAME}/nodejs-frontend:latest

# Build backend
echo "Building backend..."
docker build -t ${DOCKER_USERNAME}/flask-backend:${VERSION} ./backend
docker tag ${DOCKER_USERNAME}/flask-backend:${VERSION} ${DOCKER_USERNAME}/flask-backend:latest

echo -e "${GREEN}✅ Images built successfully!${NC}"

# Login to Docker Hub
echo -e "${YELLOW}🔐 Logging in to Docker Hub...${NC}"
docker login

# Push images
echo -e "${YELLOW}⬆️  Pushing images to Docker Hub...${NC}"

docker push ${DOCKER_USERNAME}/nodejs-frontend:${VERSION}
docker push ${DOCKER_USERNAME}/nodejs-frontend:latest

docker push ${DOCKER_USERNAME}/flask-backend:${VERSION}
docker push ${DOCKER_USERNAME}/flask-backend:latest

echo -e "${GREEN}✅ Images pushed successfully!${NC}"

# Display image information
echo -e "${YELLOW}📊 Image Information:${NC}"
echo "Frontend: ${DOCKER_USERNAME}/nodejs-frontend:${VERSION}"
echo "Backend: ${DOCKER_USERNAME}/flask-backend:${VERSION}"

echo -e "${GREEN}🎉 Deployment complete!${NC}"
