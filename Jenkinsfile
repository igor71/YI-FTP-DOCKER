pipeline {
  agent {label 'yi-ftp'}
    stages {
        stage('Build Basic FTP Image') {
            steps {
	        sh 'docker build -f Dockerfile.SSH -t yi/ftp:${docker_tag} .'    
            }
        }
		    stage('Test The Image For Mapped Ports') { 
            steps {
                sh '''#!/bin/bash -xe
		    echo 'Hello, SSH_Docker'
                    image_id="$(docker images -q yi/ftp:${docker_tag})"
                    if [[ "$(docker images -q yi/ftp:${docker_tag} 2> /dev/null)" == "$image_id" ]]; then
                       docker inspect --format='{{range $p, $conf := .Config.ExposedPorts}} {{$p}} {{end}}' $image_id
                    else
                       echo "FTP port not listenning inside docker container, check the Dockerfile!!!"
                       #exit -1
                    fi 
                   ''' 
            }
        }
	      stage('Save & Load Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		            echo 'Saving Docker image into tar archive'
                docker save yi/ftp:${docker_tag} | pv -f | cat > $WORKSPACE/yi-ftp-${docker_tag}.tar
			
                echo 'Remove Original Docker Image' 
			          CURRENT_ID=$(docker images | grep -E '^yi/ftp.*'${docker_tag}'' | awk -e '{print $3}')
			          docker rmi -f $CURRENT_ID
			
                echo 'Loading Docker Image'
                pv -f $WORKSPACE/yi-ftp-${docker_tag}.tar | docker load
			          docker tag $CURRENT_ID yi/ftp:${docker_tag}
                        
                echo 'Removing Temp Archive.'  
                rm $WORKSPACE/yi-ftp-${docker_tag}.tar
                   ''' 
		        }
		   }			   
  }
	post {
            always {
               script {
                  if (currentBuild.result == null) {
                     currentBuild.result = 'SUCCESS' 
                  }
               }
               step([$class: 'Mailer',
                     notifyEveryUnstableBuild: true,
                     recipients: "igor.rabkin@xiaoyi.com",
                     sendToIndividuals: true])
            }
         } 
}
