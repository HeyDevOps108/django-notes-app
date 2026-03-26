#!/bin/bash

docker build -t notes-app .

docker image tag notes-app:latest vedant7669/notes-app:v1

docker push vedant7669/notes-app:v1

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml