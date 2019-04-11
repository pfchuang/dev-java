FROM centos:latest
MAINTAINER "lukechuang"<poteninearn@gmail.com>

# Basic tools
RUN yum -q -y update && \
    yum -q -y install wget && \
    yum -q -y install unzip && \
    yum -q -y install vim && \
    yum -q -y install git

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

# javacomplete
RUN mkdir ~/.vim && \
    wget --quiet http://www.vim.org/scripts/download_script.php?src_id=14914 -O javacomplete.zip && \
    unzip -qq javacomplete.zip -d ~/.vim && \
    rm javacomplete.zip && \
    echo "setlocal omnifunc=javacomplete#Complete" >> ~/.vimrc && \
    echo "inoremap <buffer> . .<C-X><C-O><C-P>" >> ~/.vimrc

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

