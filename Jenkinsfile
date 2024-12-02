pipeline {
  agent any
  tools { 
        maven 'Maven_3_5_2'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh "mvn clean verify sonar:sonar -Dsonar.projectKey=asgbuggywebapp100 -Dsonar.organization=asgbuggywebapp100 -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=a6d70c2c88ea353035338a33bde8777f2c7e3f3f"
			}
        } 
        
	stage('RunSCAAnalysisUsingSnyk') {
        steps {		
			withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
				sh 'mvn snyk:test -fn'
			}
		}
	}

      
	stage('Build') { 
            steps { 
               withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
                 script{
                 app =  docker.build("asg")
                 }
               }
            }
      }

	stage('Push') {
            steps {
                script{
                    docker.withRegistry('https://022006208139.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:aws-credentials') {
                    app.push("latest")
                    }
                }
            }
      }
      	   
	stage('Kubernetes Deployment of ASG Bugg Web Application') {
	   steps {
	      withKubeConfig([credentialsId: 'kubelogin']) {
		  sh('kubectl delete all --all -n devsecops') // delete all in our namespace
		  sh ('kubectl apply -f k8s/deployment.yaml --namespace=devsecops') // run the deployment in the k8s namespace
		}
	      }
   	}
    	stage ('wait_for_testing'){
	   steps {
		   sh 'pwd; sleep 180; echo "Application Has been deployed on K8S"'
	   	}
	   }
	   
	stage('RunDASTUsingZAP') {
          steps {
		    withKubeConfig([credentialsId: 'kubelogin']) {
				sh('zap.sh -cmd -quickurl http://$(kubectl get services/asgbuggy --namespace=devsecops -o json| jq -r ".status.loadBalancer.ingress[] | .hostname") -quickprogress -quickout ${WORKSPACE}/zap_report.html') // fetch the URL dynamically of LoadBalancer
				archiveArtifacts artifacts: 'zap_report.html'
		    }
	     }
      } 
   }
}