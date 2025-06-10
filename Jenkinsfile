 pipeline {
 agent { label 'slave-server' }
 parameters {
     password(name: 'PASSWD', defaultValue: '', description: 'Please Enter your Gitlab password')
     string(name: 'IMAGETAG', defaultValue: '1', description: 'Please Enter the Image Tag to Deploy?')
     string(name: 'environment', defaultValue: 'kubernetes', description: 'Directory containing deployment files')
 }
 stages {
  stage('Deploy')
  {
    steps { 
        git branch: 'main', credentialsId: 'githubcred', url: 'https://github.com/effiong20/springboot-cd.git'
      dir ("${params.environment}") {
              sh "sed -i 's/image: adamtravis.*/image: adamtravis\\/democicd:${params.IMAGETAG}/g' deployment.yml" 
	    }
	    sh 'git config --global user.email "effiongeno20@yahoo.com"'
	    sh 'git config --global user.name "effiong20"'
	    sh 'git commit -a -m "New deployment for Build ${params.IMAGETAG}"'
	    sh "git push https://effiong20:${params.PASSWD}@github.com/effiong20/springboot-cd.git main"
    }
  }
 }
}
  