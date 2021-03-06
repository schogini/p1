pipeline {
  environment {
    registry = "schogini/my-image"
    registryCredential = "docker-hub"
    slackChannelTest = credentials('slack-test')
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

					sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Build ${env.BUILD_ID} Failed!\"}' ${env.slackChannelTest}"

				}else{
					//B016C2EFAP7
					//C017ACUDN77
					sh "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Build ${env.BUILD_ID} Succeeded!\"}' ${env.slackChannelTest}"

				
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