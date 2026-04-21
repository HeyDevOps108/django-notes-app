#!/bin/bash

kubectl port-forward service/notes-app-service -n default 8000:8000 --address=0.0.0.0

sudo -E kubectl port-forward service/ingress-nginx-controller -n ingress-nginx 80:80 --address=0.0.0.0