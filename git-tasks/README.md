### amatiev-ykhodzin

#### Members:
    Aleksandr Matiev
    Yauhen Khodzin

#### Task:
Deploy Jenkins server with Nginx web-server via Vagrant
______

Repository include 4 files:
* Vagrantfile for provisioning VM
* vagrant.sh scrypt which installs and configure Java, Nginx and Jenkins.
* nginx.conf configured file for replacing in VM
* jenkins.service file for using Jenkins
______

Vagrant wiil create VM with the name "jenkins"

For start just clone repo and enter:
```bash
vagrant up
```
After provisioning you can use Jenkins via address http://jenkins
>WARNING: don't forget add "192.168.56.101 jenkins" in your etc/hosts

For manage VM enter: 
```bash
vagrant ssh
```

Our concept of working is under [link](https://i.imgur.com/2So7Vqg.jpg)

And result graph

![Final Process](https://i.imgur.com/cqMTLzm.png)
