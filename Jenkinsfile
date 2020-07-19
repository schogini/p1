pipeline {
  environment {
    registry = "schogini/my-image"
    registryCredential = "docker-hub"
    dockerImage = ''
  }

  agent any

  stages {

	    stage('Cloning Git') {
	      steps {
	        git 'https://github.com/schogini/p1.git'
	      }
	    }
	    stage('Building image') {
	      steps{
	        script {
	          dockerImage = docker.build registry + ":$BUILD_NUMBER"
	        }
	      }
	    }
	    stage('Testing image') {
	      steps{
	        script {
	          env.TEST = sh(returnStdout: true, script: "./t1.sh ${env.BUILD_ID} ${env.registry}:${env.BUILD_ID}").trim()

				if (env.TEST != "SUCCESS") {
					currentBuild.result = 'ABORTED'
					error("Test Failed Aborting.. ${env.TEST}")
					sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Build ${env.BUILD_ID} Failed!\"}' https://hooks.slack.com/services/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"
				}else{
					sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Build ${env.BUILD_ID} Succeeded!\"}' https://hooks.slack.com/services/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"
				}
	        }
	      }
	    }
		stage('Pushing Image') {
			steps{    
				script {
			  		docker.withRegistry( '', registryCredential ) {
			    		dockerImage.push()
			  		}
				}
			}
		}  
		stage('Deploy Image') {
			steps{    
				script {
					sh "./deploy.sh schogini/my-image:${env.BUILD_ID} ${env.BUILD_ID}"
					currentBuild.result = 'SUCCESS'
				}
			}
		}  
		stage('Remove Unused docker image') {
		  steps{
		    sh "docker rmi $registry:$BUILD_NUMBER"
		  }
		}   
	}
}