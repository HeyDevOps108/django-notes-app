#!/bin/bash

docker build -t notes-app .

docker image tag notes-app:latest vedant7669/notes-app:v1

docker push vedant7669/notes-app:v1