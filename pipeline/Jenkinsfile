import hudson.FilePath
import jenkins.model.Jenkins
import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*

def func_gradle(String command){
    withEnv(["JAVA_HOME=${ tool 'java8' }", "PATH+GRADLE=${tool 'gradle4.6'}/bin"]){sh "gradle ${command}"}
}
nStage = ''
try {
    userName = currentBuild.rawBuild.getCause(Cause.UserIdCause).getUserName()}
catch(all){userName = 'an SCM change'}

def email(String status){
    status = status ?: 'SUCCESS'
    def log = currentBuild.rawBuild.getLog(20).join('\n\t\t')
    def subject = "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def consURL = new URL("${env.BUILD_URL}consoleText")
    def details = """STARTED: Job    ${env.JOB_NAME} [${env.BUILD_NUMBER}]
        Started by: ${userName}
        Stage: ${nStage}
        Runned on slave: ${env.SLAVE}
        Check console output at: ${consURL}
        
        Last 20 lines in log:
        ${log}"""
    emailext (
        to: 'mushtarda@gmail.com',
        subject: subject,
        body: details,
        attachLog: true
    )    
}

node("${SLAVE}") {
    try{
        stage('Preparation (Checking out)'){
            cleanWs()
            nStage = 'Preparation (Checking out)'
            checkout scm
        }
        stage('Building code'){
            nStage = 'Building code'
            tool name: 'java8', type: 'jdk'
            tool name: 'gradle4.6', type: 'gradle'
            tool name: 'groovy4', type: 'hudson.plugins.groovy.GroovyInstallation'
            func_gradle('build')
        }
        stage('Testing code'){
            nStage = 'Testing code'
            parallel(
                'Gradle cucumber': {
                    func_gradle('cucumber')
                },
                'Gradle jacocoTest': {
                    func_gradle('jacocoTestReport')
                },
                'Gradle test': {
                    func_gradle('test')
                }
            )
        }
        stage('Triggering job and fetching artefact after finishing'){
            nStage = 'Triggering job and fetching artefact after finishing'
            build job: 'MNTLAB-ykhodzin-child1-build-job', parameters: [[$class: 'StringParameterValue', name: 'BRANCH', value: 'ykhodzin']]
            copyArtifacts filter: '*.tar.gz', fingerprintArtifacts: true, projectName: 'MNTLAB-ykhodzin-child1-build-job', selector: lastSuccessful()//
        }
        stage('Packaging and Publishing results'){
            nStage = 'Packaging and Publishing results'
            sh """tar -xvf ykhodzin_dsl_script.tar.gz
            tar -czf ${WORKSPACE}/pipeline-ykhodzin-${BUILD_NUMBER}.tar.gz jobs.groovy Jenkinsfile -C build/libs/ mntlab-ci-pipeline@3.jar"""
            withEnv(["JAVA_HOME=${ tool 'java8' }", "PATH+GRADLE=${tool 'gradle4.6'}/bin", "PATH+GROOVY_HOME=${tool 'groovy4'}/bin"]){sh "groovy nex.groovy push ${BUILD_NUMBER}"}
        }
        stage('Asking for manual approval'){
            nStage = 'Asking for manual approval'
            //timeout(time: 10, unit: 'SECONDS') {
                input 'Confirm deploy'
            //}
        }
        stage('Deployment'){
            nStage = 'Deployment'
            withEnv(["JAVA_HOME=${ tool 'java8' }", "PATH+GRADLE=${tool 'gradle4.6'}/bin", "PATH+GROOVY_HOME=${tool 'groovy4'}/bin"]){sh "groovy nex.groovy pull ${BUILD_NUMBER}"}
            sh """tar -xvf download-${BUILD_NUMBER}.tar.gz
            java -jar mntlab-ci-pipeline@3.jar"""
        }
        stage('Sending status'){
            nStage = 'Sending status'
        }
    }
    catch(all){
        currentBuild.result = 'FAILED'
    }
    finally{  
        email(currentBuild.result)
    }
}
