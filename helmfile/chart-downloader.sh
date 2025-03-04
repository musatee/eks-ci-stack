#!/bin/bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo add bitnami "https://charts.bitnami.com/bitnami"
helm repo update

echo "Charts are downloading..."
helm pull aws-ebs-csi-driver/aws-ebs-csi-driver --destination ./charts/aws-ebs-csi-driver --version 2.35.1
helm pull bitnami/external-dns --destination ./charts/external-dns --version 6.25.0
echo "Charts download complete!"