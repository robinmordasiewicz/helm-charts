#!/bin/bash
#

CHARTVERSION='3.11.8'
cat VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' > VERSION.tmp && mv VERSION.tmp VERSION
version=`cat VERSION`

#rm index.yaml
rm jenkins-${CHARTVERSION}.tgz
rm -rf charts/jenkins

helm repo rm jenkins
helm repo rm jenkinsci
helm repo add jenkins https://charts.jenkins.io
helm pull jenkins/jenkins --version ${CHARTVERSION}
helm repo rm jenkins
tar -zxvf jenkins-${CHARTVERSION}.tgz -C charts/

cp values.yaml charts/jenkins/

cat charts/jenkins/Chart.yaml | sed -re "s/^version: ([0-9]+\.[0-9]+\.[0-9]+)-*[0-9]*/version: \1-${version}/" > charts/jenkins/Chart.yaml.tmp && mv charts/jenkins/Chart.yaml.tmp charts/jenkins/Chart.yaml

helm package charts/*

#helm repo index --url https://github.com/robinmordasiewicz/helm-charts .
helm repo index --url https://robinmordasiewicz.github.io/helm-charts .

git add . && git commit -m "creating skel" &&  git push

# helm repo rm jenkins
# helm repo rm jenkinsci

helm repo add robinmordasiewicz https://robinmordasiewicz.github.io/helm-charts

helm repo update

helm search repo robinmordasiewicz

# helm install jenkins -n r-mordasiewicz -f values.yaml robinmordasiewicz/jenkins
