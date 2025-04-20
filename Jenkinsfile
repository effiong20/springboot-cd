pipeline {
 agent { label 'demo' }
 parameters {
     password(name: 'PASSWD', defaultValue: '', description: 'Please Enter your Gitlab password')
     string(name: 'IMAGETAG', defaultValue: '1', description: 'Please Enter the Image Tag to Deploy?')
     choice(name:'environment', choices: ['functional', 'integration', 'regression', 'uat', 'release' ] ,description: 'select where need to deploy')
 }
 stages {
  stage('Deploy')
  {
    steps { 
        git branch: 'springboot', credentialsId: 'GitlabCred', url: 'https://gitlab.com/learndevopseasy/devsecops/spingboot-cd-pipeline.git'
      dir ("./${params.environment}") {
              sh "sed -i 's/image: adamtravis.*/image: adamtravis\\/democicd:$IMAGETAG/g' deployment.yml" 
	    }
	    sh 'git commit -a -m "New deployment for Build $IMAGETAG"'
	    sh "git push https://scmlearningcentre:$PASSWD@gitlab.com/learndevopseasy/devsecops/spingboot-cd-pipeline.git"
    }
  }
 }
}
