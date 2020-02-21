#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=ecme820721/udacity-ml

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run --image=$dockerpath udacity-ml --port=80 -n sre

# Step 3:
# List kubernetes pods
kubectl get pods -n  sre
podname=$(kubectl get pods -o json -n sre | jq -r .items[].metadata.name)
# Giving some time to be ready
sleep 30
# Step 4:
# Forward the container port to a host
kubectl port-forward $podname  8000:80
