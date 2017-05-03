FROM ubuntu:14.04.3

MAINTAINER Buddhika Gunathilaka <buddhika162@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

COPY AptSources /etc/apt/sources.list.d/

ENV FIREFOXVERSION 53.0+build6-0ubuntu0.14.04.1

RUN useradd -m firefox; \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886; \
    apt-get update; \
    apt-get install -y --no-install-recommends  firefox=$FIREFOXVERSION \
                                                dbus-x11 \
                                                adobe-flashplugin \
                                                libxext-dev \
                                                libxrender-dev \
                                                libxtst-dev \
						vim \
						xvfb \
						xfonts-100dpi \ 
						xfonts-75dpi \
						xfonts-cyrillic \
						xfonts-scalable \
						xorg \
						libxss1 \
						libappindicator1 \
						libindicator7 \
						apache2 apache2-doc apache2-utils \
						mysql-server php5-mysql \
						php5 libapache2-mod-php5 php5-mcrypt \
                                                oracle-java8-installer \
                                                oracle-java8-set-default

 
RUN service apache2 restart

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --no-check-certificate; \
	apt-get install -y --no-install-recommends gdebi-core; \
	gdebi -n google-chrome*.deb; \
	apt-get -y --no-install-recommends install subversion; \
	apt-get -y --no-install-recommends install libxss1 libappindicator1 libindicator7

RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key --no-check-certificate | sudo apt-key add -;  \
	sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'; \
	apt-get update; \
	apt-get -y --no-install-recommends install jenkins
