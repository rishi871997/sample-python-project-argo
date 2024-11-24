#!/bin/bash

# Variables
IMAGE="rs871997/sample-python-project" # Replace with your Docker Hub image name
DEPLOYMENT_FILE="/home/rishi/Interview-Project/argocd-repo/sample-python-project-argo/deploy/deployment.yaml"    # Path to your deployment.yaml file

# Fetch the latest version from Docker Hub
echo "Fetching the latest tag for $IMAGE from Docker Hub..."
LATEST_TAG=$(curl -s "https://hub.docker.com/v2/repositories/${IMAGE}/tags/?page_size=1" | jq -r '.results[0].name')

if [[ -z "$LATEST_TAG" ]]; then
  echo "Error: Unable to fetch the latest tag. Please check the image name or network connectivity."
  exit 1
fi

echo "Latest tag fetched: $LATEST_TAG"

# Update the version in deployment.yaml
echo "Updating deployment.yaml with the latest image version..."
if grep -q "$IMAGE" "$DEPLOYMENT_FILE"; then
  sed -i "s|$IMAGE:.*|$IMAGE:$LATEST_TAG|g" "$DEPLOYMENT_FILE"
  echo "deployment.yaml updated successfully with version $LATEST_TAG."
else
  echo "Error: Image $IMAGE not found in $DEPLOYMENT_FILE."
  exit 1
fi

# Optional: Display the updated deployment.yaml
#echo "Updated deployment.yaml:"
#cat "$DEPLOYMENT_FILE"

exit 0
