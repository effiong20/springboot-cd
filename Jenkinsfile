pipeline {
 agent { label 'demo' }
 parameters {
     password(name: 'PASSWD', defaultValue: '', description: 'Please Enter your Gitlab password')
     string(name: 'IMAGETAG', defaultValue: '1', description: 'Please Enter the Image Tag to Deploy?')
   //  choice(name:'environment', choices: ['functional', 'integration', 'regression', 'uat', 'release' ] ,description: 'select where need to deploy')
 }
 stages {
  stage('Deploy')
  {
    steps { 
        git branch: 'main', credentialsId: 'GitlabCred', url: 'https://github.com/effiong20/springboot-cd.git'
      dir ("./${params.environment}") {
              sh "sed -i 's/image: giftedis.*/image: giftedid\\/democicd:$IMAGETAG/g' deployment.yml" 
	    }
	    sh 'git commit -a -m "New deployment for Build $IMAGETAG"'
	    sh "git push https://github.com/effiong20/springboot-cd.git:$PASSWD@github.com/effiong20/springboot-cd.git"
    }
  }
 }
}
    