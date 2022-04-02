#!/bin/bash
#

helm repo rm jenkins

helm repo rm jenkinsci

helm repo add jenkins https://charts.jenkins.io

helm pull jenkins/jenkins --version 3.11.8

helm repo rm jenkins

tar -zxvf jenkins-3.11.8.tgz -C charts/

rm jenkins-3.11.8.tgz

cp values.yaml charts/jenkins/

helm package charts/*

helm repo index --url https://github.com/robinmordasiewicz/helm-charts .

git add . && git commit -m "creating skel" &&  git push

helm repo add jenkins https://robinmordasiewicz.github.io/helm-charts

helm repo update

helm search repo jenkins

# helm install jenkins -n r-mordasiewicz -f values.yaml robinmordasiewicz/jenkins
