FROM centos:latest
MAINTAINER "lukechuang"<poteninearn@gmail.com>

# Basic tools
RUN yum -q -y update && \
    yum -q -y install wget && \
    yum -q -y install unzip && \
    yum -q -y install git

# Java 8
yum -q -y install java-1.8.0-openjdk
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

# Vim 8
RUN rpm -U --quiet http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm && \
    rpm --import --quiet http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7 && \
    yum -q -y remove vim-minimal && \
    yum -q -y --enablerepo=gf-plus install vim-enhanced

# Gradle
RUN wget --quiet https://services.gradle.org/distributions/gradle-2.6-bin.zip && \
    unzip -qq gradle-2.6-bin.zip -d /opt && \
    rm -f gradle-2.6-bin.zip

ENV GRADLE_HOME /opt/gradle-2.6

# PATH
ENV PATH $GRADLE_HOME/bin:$PATH

# Vundle & vim-javacomplete2
RUN mkdir -p ~/.vim/bundle && \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    echo "set nocompatible" >> ~/.vimrc && \
    echo "filetype off" >> ~/.vimrc && \
    echo "set rtp+=~/.vim/bundle/Vundle.vim" >> ~/.vimrc && \
    echo "call vundle#begin()" >> ~/.vimrc && \
    echo "Plugin 'VundleVim/Vundle.vim'" >> ~/.vimrc && \
    echo "Plugin 'artur-shaik/vim-javacomplete2'" >> ~/.vimrc && \
    echo "call vundle#end()" >> ~/.vimrc && \
    echo "syntax on" >> ~/.vimrc && \
    echo "filetype plugin indent on" >> ~/.vimrc && \
    vim +PluginInstall +qall && \
    echo "autocmd FileType java setlocal omnifunc=javacomplete#Complete" >> ~/.vimrc

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
