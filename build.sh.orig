#!/bin/bash
#

set -e

CHARTVERSION=`cat VERSION.helmchart | sed -re "s/^([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/\1/"`
LOCALREVISION=`cat VERSION.helmchart | sed -re "s/^[0-9]+\.[0-9]+\.[0-9]+-*([0-9]*)/\1/"`
CONTAINERVERSION=`cat VERSION.container`

if [ -d tmp ]
then
  rm -rf tmp && mkdir tmp
else
  mkdir tmp
fi

if [ -d charts/jenkins ]
then
  rm -rf charts/jenkins && mkdir charts/jenkins
else
  mkdir charts/jenkins
fi

helm repo rm jenkins || true
helm repo add jenkins https://charts.jenkins.io
helm pull jenkins/jenkins --version ${CHARTVERSION} -d charts/
helm repo rm jenkins

tar -zxvf charts/jenkins-${CHARTVERSION}.tgz -C charts/

cp custom-values.yaml charts/jenkins/

cat charts/jenkins/Chart.yaml | sed -re "s/^version: [0-9]+\.[0-9]+\.[0-9]+-*[0-9]*/version: ${CHARTVERSION}-${LOCALREVISION}/" > charts/jenkins/Chart.yaml.tmp && mv charts/jenkins/Chart.yaml.tmp charts/jenkins/Chart.yaml

helm lint charts/jenkins/ -f charts/jenkins/custom-values.yaml --strict

(cd -- "charts" && helm package jenkins --version "${CHARTVERSION}-${LOCALREVISION}" --app-version ${CONTAINERVERSION} )

if [ -d tmp ]
then
  rm -rf tmp
fi

# ( cd -- "charts" && helm repo index --url https://robinmordasiewicz.github.io/helm-charts . )
