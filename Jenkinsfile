def provider = 'gcp'
// Conditionally define a variable 'impact'
if (provider == 'aws') {
  script = "aws_bash.sh"
} 
else {
  script = "gcp_bash.sh"
}

pipeline {
  agent any
	environment {
        DOCKER_IMAGE_NAME = "shuvamoy008/sparkops"
	workspace = "${env.WORKSPACE}"
	
    }
	 parameters {
        choice(
            choices: 'true\nfalse',
            description: 'Select ? ',
            name: 'ACTION')
    }
	
    
    stages {
	   
	   stage ("Running Terraform for Cloud Provisioning") {
	      when {
                expression { params.ACTION == 'true' }
               }
              steps {
	         sh "sh ${script} ${provider}"
                    }
          }

           stage('Deploy strimzi') {
             when {
                expression {  params.ACTION == 'true' }
                 }
               
		  steps {
		      script {
	                    if (provider == 'gcp') {
			       sh "gcloud container clusters get-credentials eks --region us-central1 --project poc-sed-shared-jetstream-sb"
			       sh "kubectl create ns kafka"	    
                               sh "helm repo add strimzi https://strimzi.io/charts/"
                               sh "helm install strimzi/strimzi-kafka-operator --generate-name -n kafka"
			       sh "sleep 30"
                               sh "helm install kafkachart/. --generate-name -n kafka"
                                 }
		            else {
			      
			       sh "sh awskubeconfig.sh ${workspace}/${provider}"
			       sh "aws eks --region us-east-1 update-kubeconfig --name eks"
			       sh "helm repo add strimzi https://strimzi.io/charts/"
                               sh "helm install strimzi/strimzi-kafka-operator --generate-name"
			       sh "sleep 30"
			       sh "helm install kafkachart/. --generate-name"
				    } 
	                  } 
                    }
            }
	    
	   stage('Build Docker Image') {
            when {
                expression { params.ACTION == 'true' || params.ACTION == 'false'}
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }
          stage('Push Docker Image') {
            when {
                 expression { params.ACTION == 'true' || params.ACTION == 'false'}
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') 
			{
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                        }
                     }
                 }
           }
	    
	   stage('Push mysql Images') {
            when {
                 expression { params.ACTION == 'true' }
            }
            steps {
		    script {
	                    if (provider == 'gcp') {
                                 sh "gcloud container clusters get-credentials eks --region us-central1 --project poc-sed-shared-jetstream-sb"
				 sh "kubectl apply -f mysql-deployment.yaml"
				 sh "sleep 30"
				 sh "kubectl exec -it deployment.apps/mysql mysql-client -- mysql -h mysql -ppassword  < mysql.sql"
			    }
			    else 
			    {
				 sh "aws eks --region us-east-1 update-kubeconfig --name eks"
				 sh "kubectl apply -f mysql-deployment.yaml"
				 sh "sleep 30"
				 sh "kubectl exec -it deployment.apps/mysql mysql-client -- mysql -h mysql -ppassword  < mysql.sql"
			    }
                         }
                 }
	    }
    }
}
	    


