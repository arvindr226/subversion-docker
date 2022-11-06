# subversion-docker
<img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/arvindr226/subversion?style=plastic">

For the demo Please visit to the youtube URL-: https://www.youtube.com/watch?v=nXdSoo610Vk

Blog link-: https://gotechnies.net/use-apache-subversion-on-docker-container/

# Apache Subversion
Welcome to subversion.apache.org, the online home of the Apache Subversion™ software project. 
Subversion is an open source version control system. Founded in 2000 by CollabNet, Inc., the Subversion project 
and software have seen incredible success over the past decade. 
Subversion has enjoyed and continues to enjoy widespread adoption in both the open source arena and the corporate world.

Subversion exists to be universally recognized and adopted as an open-source, centralized version control system characterized 
by its reliability as a safe haven for valuable data; the simplicity of its model and usage; and its ability to support the needs 
of a wide variety of users and projects, from individuals to large-scale enterprise operations.

# To start the docker container, use the below command.
```
$ docker-compose -p subversion up -d
```

To Stop the subversion docker contianer. Use the below command.
```
$ docker-compose -p subversion stop
```

replace or omit `-p subversion` if you want to use a different project name

## Overrides

The `docker-compose.override.yml` opens ports 80 for http and 2022 for ssh. This is good for testing, but not great for production.
Bind mounts are only performant on linux, and you probably don't want to store production data in some user's home folder.

For production, create another override file (ex `mysite.yml`) and use that to start. Ex:
```
$ docker-compose -p subversion -f docker-compose.yml -f mysite.yml
```

If you don't override the `data-volume` definition, then docker will pick the location of the volume
(see with `docker volume ls` and `docker volume inspect [volume-name]`). This is generally preferred for
production, especially on Mac/Windows hosts.

## Traefik
If you have traefik running on ports 80, and 443, using a configured `docker network` named `traefik-public` AND configured to manage ssl 
certificates via Let's Encrypt, then you do not need to export port 80 (or 443) in your site specific override. Do override the following
to configure your domain:

```
services:
  web:
    labels:
      traefik.http.routers.svn-router-http.rule: Host(`svn.example.com`)
      traefik.http.routers.svn-router-https.rule: Host(`svn.example.com`)
```

# How to create SVN Repository ?

First of all generate ssh public key using below command.
```
$ ssh-keygen 
```

Step 1-: Authenticate your localhost to docker container
```
$ ssh-copy-id root@localhost -p2222
```
Enter the password "gotechnies"

Step 2-: Create SVN repository.
```
$ ssh root@localhost -p2222 /var/www/html/create_svn.sh New_Repo
```


Step 3-: Checkout your SVN repository
```
$ svn co http://192.168.1.89/svn/New_Repo
```

Default Username and password.  

**Username-: admin**  
**Password-: gotechnies**  

To Check the repository on WebSVN. http://localhost/ or http://serverip/
