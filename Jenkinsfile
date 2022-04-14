pipeline {
  options {
    disableConcurrentBuilds()
    skipDefaultCheckout(true)
  }
  triggers {
    upstream(upstreamProjects: "jenkins", threshold: hudson.model.Result.SUCCESS)
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: ubuntu
            image: robinhoodis/ubuntu:latest
            imagePullPolicy: Always
            command:
            - cat
            tty: true
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            imagePullPolicy: IfNotPresent
            command:
            - /busybox/cat
            tty: true
            volumeMounts:
              - name: kaniko-secret
                mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
            - name: kaniko-secret
              secret:
                secretName: regcred
                items:
                  - key: .dockerconfigjson
                    path: config.json
        '''
    }
  }
  stages {
    stage('INIT') {
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage('Increment VERSION') {
      when {
        beforeAgent true
        anyOf {
          changeset "Dockerfile"
          triggeredBy cause: 'UserIdCause'
        }
      }
      steps {
        container('ubuntu') {
          sh 'sh increment-version.sh'
        }
      }
    }
  }
  post {
    always {
      cleanWs(cleanWhenNotBuilt: false,
            deleteDirs: true,
            disableDeferredWipeout: true,
            notFailBuild: true,
            patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                       [pattern: '.propsfile', type: 'EXCLUDE']])
    }
  }
}
