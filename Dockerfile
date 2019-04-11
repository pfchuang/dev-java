FROM centos:latest
MAINTAINER "lukechuang"<poteninearn@gmail.com>

# Basic tools
RUN yum -q -y update && \
    yum -q -y install wget && \
    yum -q -y install unzip && \
    yum -q -y install git

# Vim 8
RUN rpm -U --quiet http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm && \
    rpm --import --quiet http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7 && \
    yum -q -y remove vim-minimal && \
    yum -q -y --enablerepo=gf-plus install vim-enhanced

# Oracle Java 8
RUN wget --quiet --no-cookies --no-check-certificate --header \
    "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz" && \
    tar -zxf jdk-8u201-linux-x64.tar.gz -C /usr/local && \
    ln -s /usr/local/jdk1.8.0_201 /usr/bin/java && \
    rm -f jdk-8u201-linux-x64.tar.gz

ENV JAVA_HOME /usr/bin/java

# Gradle
RUN wget --quiet https://services.gradle.org/distributions/gradle-2.6-bin.zip && \
    unzip -qq gradle-2.6-bin.zip -d /opt && \
    rm -f gradle-2.6-bin.zip

ENV GRADLE_HOME /opt/gradle-2.6

# PATH
ENV PATH $GRADLE_HOME/bin:$JAVA_HOME/bin:$PATH

# panthogen & javacomplete
RUN mkdir -p /root/.vim/autoload /root/.vim/bundle && \
    wget --quiet -P /root/.vim/autoload https://tpo.pe/pathogen.vim && \
    echo "execute pathogen#infect()" >> /root/.vimrc && \
    echo "syntax on" >> /root/.vimrc && \
    echo "filetype plugin indent on" >> /root/.vimrc && \
    git clone https://github.com/artur-shaik/vim-javacomplete2.git /root/.vim/bundle/vim-javacomplete2 && \
    echo "autocmd FileType java setlocal omnifunc=javacomplete#Complete" >> /root/.vimrc

# gradle-templates
RUN mkdir /data && \
    echo "buildscript {" >> /data/build.gradle && \
    echo "    repositories {" >> /data/build.gradle && \
    echo "        maven {" >> /data/build.gradle && \
    echo "            url 'http://dl.bintray.com/cjstehno/public'" >> /data/build.gradle && \
    echo "        }" >> /data/build.gradle && \
    echo "    }" >> /data/build.gradle && \
    echo "    dependencies {" >> /data/build.gradle && \
    echo "        classpath 'gradle-templates:gradle-templates:1.5'" >> /data/build.gradle && \
    echo "    }" >> /data/build.gradle && \
    echo "}" >> /data/build.gradle && \
    echo "apply plugin:'templates'" >> /data/build.gradle

VOLUME /data

WORKDIR /data

# Define default command
CMD ["bash"]

