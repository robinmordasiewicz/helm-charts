pipeline {
  options {
    disableConcurrentBuilds()
  }
  agent any
  stages {
    stage('Init') {
      steps {
        sh 'mkdir -p argocd'
        dir ( 'argocd' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/argocd.git'
        }
      }
    }
    stage('increment version') {
      steps {
        dir ( 'argocd' ) {
          sh 'sh increment-helm-version.sh'
        }
      }
    }
    stage('commit version') {
      steps {
        dir ( 'argocd' ) {
          sh 'git config user.email "robin@mordasiewicz.com"'
          sh 'git config user.name "Robin Mordasiewicz"'
          sh 'git add .'
          sh 'git diff --quiet && git diff --staged --quiet || git commit -am "Jenkins Helmchart `cat ../VERSION.helmchart`"'
          withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
            sh 'git diff --quiet && git diff --staged --quiet || git push'
          }
        }
      }
    }
    stage('cleanup') {
      steps {
        sh 'rm -rf argocd'
      }
    }
  }
}
