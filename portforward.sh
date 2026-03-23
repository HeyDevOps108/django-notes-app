#!/bin/bash

kubectl port-forward service/notes-app-service -n default 8000:8000 --address=0.0.0.0