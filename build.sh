#!/bin/bash
#

helm repo rm jenkins

helm repo rm jenkinsci

helm pull jenkins/jenkins --version 3.11.8

tar -zxvf jenkins-3.11.8.tgz -C charts/

cp values.yaml charts/jenkins/

helm package charts/*

helm repo index --url https://github.com/robinmordasiewicz/helm-charts .

helm repo add jenkins https://robinmordasiewicz.github.io/helm-charts

helm install jenkins -n r-mordasiewicz -f values.yaml jenkins/jenkins
