#!/bin/bash

sudo apt update -y
set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail

echo "🚀 Starting installation of Docker, Kind, and kubectl..."

# ----------------------------
# 1. Install Docker
# ----------------------------
if ! command -v docker &>/dev/null; then
  echo "📦 Installing Docker..."
  sudo apt-get update -y
  sudo apt-get install -y docker.io

  echo "👤 Adding current user to docker group..."

  sudo usermod -aG docker $USER

  echo "✅ Docker installed and user added to docker group."
else
  echo "✅ Docker is already installed."
fi

# ----------------------------
# 2. Install Kind (based on architecture)
# ----------------------------
if ! command -v kind &>/dev/null; then
  echo "📦 Installing Kind..."

  ARCH=$(uname -m)
  if [ "$ARCH" = "x86_64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
  elif [ "$ARCH" = "aarch64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
  else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
  fi

  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
  echo "✅ Kind installed successfully."
else
  echo "✅ Kind is already installed."
fi



if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl..."

  sudo apt install -y apt-transport-https ca-certificates curl

  sudo usermod -aG docker ubuntu

  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt update
  sudo apt install -y kubectl
fi

# Verify using loop
while ! command -v kubectl >/dev/null 2>&1; do
  echo "Still not available, retrying..."
  sleep 3
done

echo "kubectl installed successfully!"
kubectl version --client

# ----------------------------
# 4. Confirm Versions
# ----------------------------
echo
echo "🔍 Installed Versions:"
docker --version
kind --version
kubectl version --client --output=yaml

echo
echo "🎉 Docker, Kind, and kubectl installation complete!"

echo "installing k8s cluster"

cat <<EOF > kind-config.yml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role : control-plane
    image: kindest/node:v1.33.1
  - role : worker
    image: kindest/node:v1.33.1
    extraPortMappings:
     - containerPort: 80
       protocol: TCP
     - containerPort: 443
       protocol: TCP
EOF

kind create cluster --config kind-config.yml --name notes-app-cluster

export HOME=/ubuntu
export KUBECONFIG=/ubuntu/.kube/config

# explicitly save kubeconfig
mkdir -p /ubuntu/.kube
kind get kubeconfig --name notes-app-cluster > /ubuntu/.kube/config