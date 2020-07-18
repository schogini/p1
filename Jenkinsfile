node {  
  stage 'Checkout'
  	git url: 'https://github.com/schogini/p1.git'  

  stage 'Build' 
  	docker.build("my-image:${env.BUILD_ID}")

  stage 'Test'
    env.TEST = sh(returnStdout: true, script: "./t1.sh ${env.BUILD_ID} my-image:${env.BUILD_ID}").trim()

   stage 'Deploy'
	if (env.TEST == "SUCCESS") {

		echo "Test Succeeded..  ${env.TEST}"

		sh "docker tag my-image:${env.BUILD_ID} schogini/my-image:${env.BUILD_ID}"

		sh "./deploy.sh schogini/my-image:${env.BUILD_ID} ${env.BUILD_ID}"

	} else {
		echo "Test Failed Aborting.. ${env.TEST}"
	}
}