pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    AWS_REGION     = 'us-east-2'
    CLUSTER_NAME   = 'tc2-teststaging-cluster'
    ECR_REGISTRY   = '942010118414.dkr.ecr.us-east-2.amazonaws.com'
    ECR_REPOSITORY = 'tc2-teststaging-node-app'
    APP_DIR        = 'app'
    CHART_DIR      = 'node-app-helm'
    RELEASE_NAME   = 'node-app'
    K8S_NAMESPACE  = 'node-app'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Prepare') {
      steps {
        script {
          env.IMAGE_URI = "${env.ECR_REGISTRY}/${env.ECR_REPOSITORY}"
          env.IMAGE_TAG = env.GIT_COMMIT.take(8)
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build \
            -t "${IMAGE_URI}:${IMAGE_TAG}" \
            -t "${IMAGE_URI}:latest" \
            "${APP_DIR}"
        '''
      }
    }

    stage('Push To ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region "${AWS_REGION}" | \
            docker login --username AWS --password-stdin "${ECR_REGISTRY}"

          docker push "${IMAGE_URI}:${IMAGE_TAG}"
          docker push "${IMAGE_URI}:latest"
        '''
      }
    }

    stage('Deploy With Helm') {
      steps {
        sh '''
          aws eks update-kubeconfig \
            --region "${AWS_REGION}" \
            --name "${CLUSTER_NAME}"

          helm upgrade --install "${RELEASE_NAME}" "${CHART_DIR}" \
            --namespace "${K8S_NAMESPACE}" \
            --create-namespace \
            --set image.repository="${IMAGE_URI}" \
            --set image.tag="${IMAGE_TAG}"
        '''
      }
    }
  }

  post {
    always {
      sh '''
        docker logout "${ECR_REGISTRY}" || true
      '''
    }
  }
}