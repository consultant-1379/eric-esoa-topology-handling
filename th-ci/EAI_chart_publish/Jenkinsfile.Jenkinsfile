#!/usr/bin/env groovy

def defaultBobImage = 'armdocker.rnd.ericsson.se/proj-adp-cicd-drop/bob.2.0:1.7.0-55'
def bob = new BobCommand()
        .bobImage(defaultBobImage)
        .envVars([
                VERSION: '${VERSION}',
                HOME:'${HOME}',
                GERRIT_CHANGE_NUMBER:'${GERRIT_CHANGE_NUMBER}',
                USER:'${USER}',
                SERO_ARTIFACTORY_REPO_USER:'${SERO_ARTIFACTORY_REPO_USR}',
                SERO_ARTIFACTORY_REPO_PASS:'${SERO_ARTIFACTORY_REPO_PSW}',
        ])
        .needDockerSocket(true)
        .toString()

pipeline {
    agent {
        node {
            label params.SLAVE
        }
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '50'))
    }

    environment {
        SERO_ARTIFACTORY_REPO = credentials('esoadm100-sero-artifactory')
    }

    stages {
        stage('Clean') {
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml clean" 
            }
        }
        stage('Pull Images From Dev') {
            when {
                expression { PUBLISH == "IMAGE" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml pull-images"
            }
        }
        stage('Tag Images') {
            when {
                expression { PUBLISH == "IMAGE" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml tag-images"
            }
        }
        stage('Publish Images to Drop') {
            when {
                expression { PUBLISH == "IMAGE" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml publish-images"
            }
            post {
                always {
                    script {
                        sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml remove-images"
                    }
                }
            }
        }
        stage('Init') {
            when {
                expression { PUBLISH == "CHART" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml init"
                archiveArtifacts 'artifact.properties'
            }
        }
        stage('Pull Charts from Dev') {
            when {
                expression { PUBLISH == "CHART" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml pull-helm-chart"
            }
        }
        stage('Publish Charts to Drop') {
            when {
                expression { PUBLISH == "CHART" }
            }
            steps {
                sh "${bob} -r th-ci/EAI_chart_publish/ruleset2.0.yaml publish-helm-chart"
            }
        }
    }
}

// More about @Builder: http://mrhaki.blogspot.com/2014/05/groovy-goodness-use-builder-ast.html
import groovy.transform.builder.Builder
import groovy.transform.builder.SimpleStrategy

@Builder(builderStrategy = SimpleStrategy, prefix = '')
class BobCommand {
    def bobImage = 'bob.2.0:latest'
    def envVars = [:]
    def needDockerSocket = false

    String toString() {
        def env = envVars
                .collect({ entry -> "-e ${entry.key}=\"${entry.value}\"" })
                .join(' ')

        def cmd = """\
            |docker run
            |--init
            |--rm
            |--workdir \${PWD}
            |--user \$(id -u):\$(id -g)
            |-v \${PWD}:\${PWD}
            |-v /etc/group:/etc/group:ro
            |-v /etc/passwd:/etc/passwd:ro
            |-v \${HOME}:\${HOME}
            |${needDockerSocket ? '-v /var/run/docker.sock:/var/run/docker.sock' : ''}
            |${env}
            |\$(for group in \$(id -G); do printf ' --group-add %s' "\$group"; done)
            |--group-add \$(stat -c '%g' /var/run/docker.sock)
            |${bobImage}
            |"""
        return cmd
                .stripMargin()           // remove indentation
                .replace('\n', ' ')      // join lines
                .replaceAll(/[ ]+/, ' ') // replace multiple spaces by one
    }
}