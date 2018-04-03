import hudson.plugins.git.GitSCM
import hudson.tasks.Shell
import jenkins.model.Jenkins
import hudson.model.FreeStyleProject
import hudson.plugins.git.GitSCM
import javaposse.jobdsl.plugin.*
import hudson.plugins.ws_cleanup.*

def url = "https://github.com/MNT-Lab/groovy-scripts.git"
//def branch = "ykhodzin"
def branch = "master"
def jobName = "MNT-CD-module9-extcreated-job"


project = Jenkins.instance.createProject(FreeStyleProject, jobName)
def gitScm = new GitSCM(url)
gitScm.branches = [new hudson.plugins.git.BranchSpec("*/${branch}")]
project.scm = gitScm
project.getBuildersList().clear()
project.getBuildersList().add(new Shell("echo 'Hello world'"))
project.buildWrappersList.add(new PreBuildCleanup(null, true, "", ""))
project.save()
