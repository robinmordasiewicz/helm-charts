#!/bin/bash
#

helm repo rm jenkins

helm repo rm jenkinsci

helm pull jenkinsci/jenkins --version 3.11.8

tar -zxvf jenkins-3.11.8.tgz -C helm-chart-sources/

cp values.yaml helm-chart-sources/jenkins

helm package helm-chart-sources/*

helm repo index --url https://github.com/robinmordasiewicz/jenkins-helm .

helm repo add jenkins https://robinmordasiewicz.github.io/jenkins-helm/

helm install jenkins -n r-mordasiewicz -f values.yaml jenkinsci/jenkins
