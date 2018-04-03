#!/bin/bash

sudo yum install -y git
sudo yum install -y net-tools
sudo yum install epel-release -y
sudo yum install java-1.8.0-openjdk-devel -y    
sudo yum install nginx -y
groupadd jenkins
useradd jenkins -g jenkins

sudo cp -rf /vagrant/nginx.conf /etc/nginx/nginx.conf
sudo systemctl enable nginx
sudo systemctl start nginx

sudo export JENKINS_HOME=/opt/jenkins/master
sudo export JENKINS_DIR=/opt/jenkins/bin
sudo bash -c 'echo "JENKINS_HOME=/opt/jenkins/master" >> /etc/environment'
sudo bash -c 'echo "JENKINS_DIR=/opt/jenkins/bin" >> /etc/environment'

sudo mkdir -p /opt/jenkins/{bin,master}
sudo chown -R jenkins:jenkins /opt/jenkins
cd /opt/jenkins/bin
wget http://ftp-chi.osuosl.org/pub/jenkins/war-stable/2.89.4/jenkins.war

sudo cp /vagrant/jenkins.service /etc/systemd/system
sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service
