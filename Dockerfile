FROM jenkins:2.60.3

USER root
RUN apt-get update
RUN apt-get install -y nano
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN mkdir -m 777 /var/buildfiles
RUN mkdir -m 777 /var/nodejs_jenkins

ADD ./override.profile /var/buildfiles/.profile
ADD ./override.npmrc /var/buildfiles/.npmrc
ADD ./override.bashrc /var/buildfiles/.bashrc
RUN chmod 644 /var/buildfiles/.npmrc
RUN chmod 644 /var/buildfiles/.profile
RUN chmod 644 /var/buildfiles/.bashrc
RUN cp /var/buildfiles/.npmrc /usr/share/jenkins/ref/.npmrc.override
RUN cp /var/buildfiles/.profile /usr/share/jenkins/ref/.profile.override
RUN cp /var/buildfiles/.bashrc /usr/share/jenkins/ref/.bashrc.override

USER jenkins
RUN cp /var/buildfiles/.npmrc /var/jenkins_home/.npmrc && \
    cp /var/buildfiles/.profile /var/jenkins_home/.profile && \
    mkdir /var/nodejs_jenkins/.npm-global && \
    npm config set prefix '/var/nodejs_jenkins/.npm-global' && \
    echo 'export PATH=/var/nodejs_jenkins/.npm-global/bin:$PATH' >> /var/jenkins_home/.profile && \
    PATH=/var/nodejs_jenkins/.npm-global/bin:$PATH && \
    npm install -g typescript@2.7.2 gulp-cli@1.2.2 ionic@3.19.1 pm2@2.10.1 sitemap-generator-cli@6.2.6 @angular/cli@1.7.1   
