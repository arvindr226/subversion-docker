FROM ubuntu:16.04
MAINTAINER  Arvind Rawat <arvindr226@gmail.com>

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
   		   apache2 \
                   subversion \
                   git \
                   curl \
                   zip \
		   unzip \
                   nano \
		   php \
   		   libapache2-mod-php \
                   supervisor \
     		   wget \
                   openssh-server \
                   vim \
                   libapache2-svn \
		   php-xml \
                   libsvn-perl \
                   openssl \
          && rm -r /var/lib/apt/lists/*

RUN a2enmod dav_svn
RUN a2enmod dav
RUN a2enmod ssl
# Enable https selfsigned certificate
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt -subj '/CN=localhost/O=My Company Name LTD./C=US'
RUN cat /etc/ssl/certs/*.crt /etc/ssl/certs/*key >> /etc/ssl/certs/ssl-cert-snakeoil.pem
RUN cp /etc/ssl/certs/localhost.key /etc/ssl/private/ssl-cert-snakeoil.key

WORKDIR /var/www/html
RUN curl -L -o tmp.zip -k https://github.com/websvnphp/websvn/archive/refs/tags/2.6.1.zip && unzip tmp.zip && rm tmp.zip && mv websvn-* ../

RUN mv /var/www/websvn-*/* /var/www/html/
RUN chown -R www-data:www-data /var/www/html
RUN rm /var/www/html/index.html
RUN cp /var/www/html/include/distconfig.php /var/www/html/include/config.php
RUN mkdir -p /var/lib/svn/FirstRepo
RUN svnadmin create --fs-type fsfs /var/lib/svn/FirstRepo
RUN chmod -R 775 /var/lib/svn
#RUN htpasswd -c /etc/global.htpasswd admin 
RUN htpasswd -cbs /etc/global.htpasswd admin gotechnies
RUN echo "\$config->parentPath(\"/var/lib/svn\");"  >> /var/www/html/include/config.php
RUN echo "\$config->addRepository(\"FirstRepo\", \"file:///var/lib/svn/FirstRepo\");" >> /var/www/html/include/config.php
RUN  echo "<Location /svn> \n  DAV svn \n  SVNParentPath /var/lib/svn \n </Location>" >> /etc/apache2/mods-enabled/dav_svn.conf


#ssh enabled
RUN mkdir /var/run/sshd
RUN echo 'root:gotechnies' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY create_svn.sh  ./create_svn.sh
RUN chmod +x ./create_svn.sh

# Ports
EXPOSE 80
EXPOSE 443
EXPOSE 22
CMD ["/usr/bin/supervisord"]
