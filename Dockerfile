FROM centos:latest
MAINTAINER "lukechuang"<poteninearn@gmail.com>

# Basic tools
RUN yum -q -y update && \
    yum -q -y install wget && \
    yum -q -y install unzip && \
    yum -q -y install vim && \
    yum -q -y install git

# Oracle Java 8
RUN wget --quiet --load-cookies /tmp/cookies.txt \
    "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies \
    /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
    'https://drive.google.com/uc?export=download&id=143jwThgXOenC09yiQ3SrNfL_rCWnUS8h' \
    -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=143jwThgXOenC09yiQ3SrNfL_rCWnUS8h" \
    -O jdk-8u201-linux-x64.tar.gz && rm -rf /tmp/cookies.txt && \
    tar -zxf jdk-8u201-linux-x64.tar.gz -C /usr/local && \
    ln -s /usr/local/jdk1.8.0_201 /usr/bin/java && \
    rm -f jdk-8u201-linux-x64.tar.gz

ENV JAVA_HOME /usr/bin/java

# Gradle
RUN wget --quiet https://services.gradle.org/distributions/gradle-2.6-bin.zip && \
    unzip -qq gradle-2.6-bin.zip -d /opt && \
    rm -f gradle-2.6-bin.zip && \
    mkdir ~/.gradle && \
    echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties

ENV GRADLE_HOME /opt/gradle-2.6

# PATH
ENV PATH $GRADLE_HOME/bin:$JAVA_HOME/bin:$PATH

# .vimrc & Vim-plugins
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    wget --quiet https://github.com/pfchuang/dev-java/raw/master/.vimrc -O ~/.vimrc && \
    vim +PluginInstall +qall && \
    echo "alias vi='vi -u NONE'" >> /etc/bashrc

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

