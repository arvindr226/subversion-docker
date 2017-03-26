# subversion-docker

For the demo Please visit to the youtube URL-: https://www.youtube.com/watch?v=nXdSoo610Vk
# Apache Subversion
Welcome to subversion.apache.org, the online home of the Apache Subversion™ software project. 
Subversion is an open source version control system. Founded in 2000 by CollabNet, Inc., the Subversion project 
and software have seen incredible success over the past decade. 
Subversion has enjoyed and continues to enjoy widespread adoption in both the open source arena and the corporate world.


Subversion exists to be universally recognized and adopted as an open-source, centralized version control system characterized 
by its reliability as a safe haven for valuable data; the simplicity of its model and usage; and its ability to support the needs 
of a wide variety of users and projects, from individuals to large-scale enterprise operations.

# Run the docker container like below commands
<pre>
$ docker run -d -p 80:80 -p 2222:22 -p 443:443 arvindr226/subversion
</pre>

Please create a file docker-compose.yml, add the below content.
<pre>
version: "2.0"
services:
  web:
    container_name: subversions
    image: arvindr226/subversion
    ports:
       - "80:80"
       - "443:443"
       - "2222:22"
</pre>

# To start the docker container, use the below command.
<pre>
$ docker-compose up -d
</pre>

To Stop the subversion docker contianer. Use the below command.
<pre>
$ docker-compose stop
</pre>

# How to create SVN Repository ?

First of all generate ssh public key using below command.
<pre>
$ ssh-keygen 
</pre>

Step 1-: Authenticate your localhost to docker container
<pre>
$ ssh-copy-id root@localhost -p2222
</pre>
Enter the password "gotechnies"

Step 2-: Create SVN repository.
<pre>
$ ssh root@localhost -p2222 /create_svn.sh New_Repo
</pre>


Step 3-: Checkout your SVN repository
<pre>
$ svn co http://192.168.1.89/svn/New_Repo
</pre>

Default Username and password.
Username-: admin
Password-: gotechnies
To Check the repository on WebSVN. http://localhost/ or http://serverip/
