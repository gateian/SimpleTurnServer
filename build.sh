#!/bin/bash

# Build script for TURN Server Docker image
# This script builds the Docker image and optionally runs it for testing

set -e

IMAGE_NAME="turn-server"
CONTAINER_NAME="turn-server-test"

echo "Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .

echo "Docker image built successfully!"

# Ask if user wants to run the container for testing
read -p "Do you want to run the container for testing? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Stop and remove existing test container if it exists
    if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "Stopping and removing existing test container..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
    fi
    
    echo "Starting test container..."
    echo "Note: You'll need to set your EXTERNAL_IP for proper testing"
    
    docker run -d \
        --name $CONTAINER_NAME \
        --network host \
        -e EXTERNAL_IP=${EXTERNAL_IP:-"127.0.0.1"} \
        -e TURN_USERNAME=testuser \
        -e TURN_PASSWORD=testpass123 \
        -e REALM=localhost \
        -e DEBUG_LEVEL=INFO \
        $IMAGE_NAME
    
    echo "Container started! You can:"
    echo "  - View logs: docker logs -f $CONTAINER_NAME"
    echo "  - Stop container: docker stop $CONTAINER_NAME"
    echo "  - Remove container: docker rm $CONTAINER_NAME"
    echo ""
    echo "Test your TURN server at: turn:${EXTERNAL_IP:-127.0.0.1}:3478"
    echo "Username: testuser"
    echo "Password: testpass123"
fi

echo "Build complete!" 