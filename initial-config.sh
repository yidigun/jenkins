#!/bin/sh

# Generate SSH key
if [ ! -f $JENKINS_HOME/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f $JENKINS_HOME/.ssh/id_rsa -N "" && \
    echo "Genterated SSH Public Key is:" && \
      cat $JENKINS_HOME/.ssh/id_rsa.pub
fi

# Initial config files
if [ ! -f $JENKINS_HOME/hudson.plugins.git.GitTool.xml ]; then
  cat <<EOF >$JENKINS_HOME/hudson.plugins.git.GitTool.xml
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.git.GitTool_-DescriptorImpl plugin="git-client"><installations class="hudson.plugins.git.GitTool-array"><hudson.plugins.git.GitTool><name>Default Git</name><home>/usr/bin/git</home><properties/></hudson.plugins.git.GitTool></installations></hudson.plugins.git.GitTool_-DescriptorImpl>
EOF
fi
if [ ! -f $JENKINS_HOME/hudson.plugins.gradle.Gradle.xml ]; then
  cat <<EOF >$JENKINS_HOME/hudson.plugins.gradle.Gradle.xml
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.gradle.Gradle_-DescriptorImpl plugin="gradle"><installations><hudson.plugins.gradle.GradleInstallation><name>Default Gradle</name><home>/usr/share/gradle</home><properties/><gradleHome>/opt/gradle</gradleHome></hudson.plugins.gradle.GradleInstallation></installations></hudson.plugins.gradle.Gradle_-DescriptorImpl>
EOF
fi
if [ ! -f $JENKINS_HOME/hudson.tasks.Ant.xml ]; then
  cat <<EOF >$JENKINS_HOME/hudson.tasks.Ant.xml
<?xml version='1.1' encoding='UTF-8'?>
<hudson.tasks.Ant_-DescriptorImpl plugin="ant@475.vf34069fef73c"><installations><hudson.tasks.Ant_-AntInstallation><name>Default Ant</name><home>/usr/share/ant</home><properties/></hudson.tasks.Ant_-AntInstallation></installations></hudson.tasks.Ant_-DescriptorImpl>
EOF
fi
if [ ! -f $JENKINS_HOME/hudson.tasks.Maven.xml ]; then
  cat <<EOF >$JENKINS_HOME/hudson.tasks.Maven.xml
<?xml version='1.1' encoding='UTF-8'?>
<hudson.tasks.Maven_-DescriptorImpl><installations><hudson.tasks.Maven_-MavenInstallation><name>Default Maven</name><home>/opt/maven</home><properties/></hudson.tasks.Maven_-MavenInstallation></installations></hudson.tasks.Maven_-DescriptorImpl>
EOF
fi

