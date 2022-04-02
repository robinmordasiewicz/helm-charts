#!/bin/bash
#

CHARTVERSION=`cat VERSION | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/"`

LOCALREVISION=`echo $LOCALREVISION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`
echo "${CHARTVERSION}-${LOCALREVISION}" > VERSION

rm jenkins-${CHARTVERSION}.tgz
rm -rf charts/jenkins

helm repo add jenkins https://charts.jenkins.io
helm pull jenkins/jenkins --version ${CHARTVERSION}
helm repo rm jenkins
tar -zxvf jenkins-${CHARTVERSION}.tgz -C charts/

cp values.yaml charts/jenkins/

cat charts/jenkins/Chart.yaml | sed -re "s/^version: [0-9]+\.[0-9]+\.[0-9]+-*[0-9]*/version: ${CHARTVERSION}-${LOCALREVISION}/" > charts/jenkins/Chart.yaml.tmp && mv charts/jenkins/Chart.yaml.tmp charts/jenkins/Chart.yaml

helm package charts/*

helm repo index --url https://robinmordasiewicz.github.io/helm-charts .

