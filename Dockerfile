FROM ubuntu:14.04.3

MAINTAINER Buddhika Gunathilaka <buddhika162@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

COPY AptSources /etc/apt/sources.list.d/

ENV FIREFOXVERSION 53.0+build6-0ubuntu0.14.04.1

RUN useradd -m firefox
#copy oracle sources
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections

#install essential tools
RUN apt-get update && apt-get -y install \
    wget

#copy jenkins sources
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key --no-check-certificate | sudo apt-key add -  \
	&& sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2 \
        apache2-doc \
        apache2-utils \
        adobe-flashplugin \
        dbus-x11 \
        firefox=$FIREFOXVERSION \
        jenkins \
        libappindicator1 \
        libapache2-mod-php5 \
        libindicator7 \
        libxext-dev \
        libxrender-dev \
        libxss1 \
        libxtst-dev \
        mysql-server \
        openssh-server \
        oracle-java8-installer \
        oracle-java8-set-default \
        php5  \
        php5-mcrypt \
        php5-mysql \
        vim \
        xfonts-100dpi \
        xfonts-75dpi \
        xfonts-cyrillic \
        xfonts-scalable \
        xorg \
        xvfb

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --no-check-certificate; \
	apt-get install -y --no-install-recommends gdebi-core; \
	gdebi -n google-chrome*.deb; \
	apt-get -y --no-install-recommends install subversion; \
	apt-get -y --no-install-recommends install libxss1 libappindicator1 libindicator7


# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
#default ssh user orangehrm with password "password"
RUN useradd -ms /bin/bash -p sa3tHJ3/KuYvI orangehrm
RUN echo "root:root" | chpasswd



EXPOSE 443 8080

VOLUME /var/www/html



# Docker startup
CMD ["/usr/sbin/sshd", "-D"]

