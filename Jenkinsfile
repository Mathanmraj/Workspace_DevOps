pipeline {
    agent { label 'ansible' }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'Workspace_DevOps',
                    url: 'https://github.com/Mathanmraj/Workspace_DevOps.git'
            }
        }

        stage('Repository Verification') {
            steps {
                sh '''
                    echo "===== Repository ====="
                    git branch --show-current

                    echo "===== Commit ====="
                    git log -1 --oneline

                    echo "===== Ansible Files ====="
                    find Ansible -maxdepth 3 -type f | sort
                '''
            }
        }

        stage('Ansible Configuration') {
            steps {
                sh '''
                    export ANSIBLE_CONFIG="$WORKSPACE/Ansible/ansible.cfg"

                    echo "===== Ansible Version ====="
                    ansible --version

                    echo "===== Inventory ====="
                    ansible-inventory --graph
                '''
            }
        }

        stage('Ansible Syntax Check') {
            steps {
                sh '''
                    export ANSIBLE_CONFIG="$WORKSPACE/Ansible/ansible.cfg"

                    echo "===== Playbook Syntax Check ====="
                    ansible-playbook --syntax-check Ansible/playbooks/site.yml
                '''
            }
        }

        stage('Ansible Ping') {
            steps {
                sshagent(credentials: ['jenkins-linux-target']) {
                    sh '''
                        export ANSIBLE_CONFIG="$WORKSPACE/Ansible/ansible.cfg"

                        echo "===== SSH Test ====="
                        ssh -o StrictHostKeyChecking=no \
                            ansible@Linux_Target \
                            "hostname && whoami"

                        echo "===== Ansible Ping ====="
                        ansible Linux_Target -m ping
                    '''
                }
            }
        }

        stage('Ansible Check Mode') {
            steps {
                sshagent(credentials: ['jenkins-linux-target']) {
                    sh '''
                        export ANSIBLE_CONFIG="$WORKSPACE/Ansible/ansible.cfg"

                        echo "===== Ansible Check Mode ====="
                        ansible-playbook --check Ansible/playbooks/site.yml
                    '''
                }
            }
        }

        stage('Ansible Deployment') {
            steps {
                sshagent(credentials: ['jenkins-linux-target']) {
                    sh '''
                        export ANSIBLE_CONFIG="$WORKSPACE/Ansible/ansible.cfg"

                        echo "===== Ansible Deployment ====="
                        ansible-playbook Ansible/playbooks/site.yml
                    '''
                }
            }
        }

        stage('Nginx Verification') {
            steps {
                sshagent(credentials: ['jenkins-linux-target']) {
                    sh '''
                        echo "===== Nginx Verification ====="

                        echo "===== Nginx Configuration Test ====="
                        ssh -o StrictHostKeyChecking=no \
                            ansible@Linux_Target \
                            "sudo nginx -t"

                        echo "===== Nginx Port 80 ====="
                        ssh -o StrictHostKeyChecking=no \
                            ansible@Linux_Target \
                            "sudo ss -lnt | grep ':80'"

                        echo "===== Nginx HTTP Test ====="
                        ssh -o StrictHostKeyChecking=no \
                            ansible@Linux_Target \
                            "python3 -c \\"import urllib.request; print(urllib.request.urlopen('http://127.0.0.1').status)\\""
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '===== CI/CD PIPELINE SUCCESS ====='
            echo 'Ansible deployment and Nginx verification completed successfully.'
        }

        failure {
            echo '===== CI/CD PIPELINE FAILED ====='
            echo 'Check the failed stage and Jenkins console output.'
        }

        always {
            echo '===== PIPELINE COMPLETED ====='
        }
    }
}
