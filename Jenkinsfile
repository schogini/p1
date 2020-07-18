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

		env.SVC = sh(returnStdout: true, script: "docker service ls|grep -c tmp-svc").trim()

		// --update-delay
		
		if (env.SVC == "1") {
			echo "Doing a Rolling Update..  ${env.TEST}"
			sh "docker service update --env-add WEB=${env.BUILD_ID} --image schogini/my-image:${env.BUILD_ID} tmp-svc"
		} else {
			echo "Deploying Application..  ${env.TEST}"
			sh "docker service create --name tmp-svc --replicas 2 --publish 8080:8123 --env WEB=${env.BUILD_ID} schogini/my-image:${env.BUILD_ID}"
		}
	} else {
		echo "Test Failed Aborting.. ${env.TEST}"
	}
}