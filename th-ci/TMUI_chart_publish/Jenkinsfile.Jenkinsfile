#!/usr/bin/env groovy
/* IMPORTANT:
 *
 * In order to make this pipeline work, the following configuration on Jenkins is required:
 * - slave with a specific label (see pipeline.agent.label below)
 */

def bob = "bob/bob -r \${WORKSPACE}/th-ci/TMUI_chart_publish/ruleset2.0.yaml"


pipeline {
    agent {
        label 'so_slave'
    }
    parameters {
        string(name: 'ARM_SELI_USER', defaultValue: 'ossapps100-user-credentials', description: 'Jenkins secret ID for ARM Registry Credentials')
        string(name: 'Version', defaultValue: '0.0.0', description: 'Common topology trouble management UI Version')
    }
  stages{
    stage('Prepare') {
      steps {
        sh 'git clone ssh://gerrit.ericsson.se:29418/adp-cicd/bob/'
      }
    }
    stage('Init') {
      steps {
        sh "${bob} init"
          archiveArtifacts 'artifact.properties'
      }
    } 
    stage("pull the chart and binary image file"){
      steps{
        script{
          withCredentials([usernamePassword(credentialsId: params.ARM_SELI_USER, usernameVariable: 'USER_USERNAME', passwordVariable: 'USER_PASSWORD')]) {
            sh "${bob} pull-files"
          }
        }
      }
    }
    stage("build, push and remove the image"){
      steps{
        sh "${bob} load-image"
        sh "${bob} tag-image"
        sh "${bob} push-image"
        sh "${bob} remove-image"
      }
    }
    stage("helm package th chart"){
      steps{
        sh "${bob} package:unzip"
        //update eric-product-info file.
        sh """
        sed -i 's/repoPath:.*/repoPath: "proj-orchestration-so"/' "eric-oss-topo-trouble-mngmt-ui/eric-product-info.yaml"
        """
        sh "${bob} package:helm-package"

      }
    }
    stage("publish the helm chart"){
      steps{
        sh "${bob} publish"
      }
    }
  }
  post{
    always{
      cleanWs()
    }
  }
}
