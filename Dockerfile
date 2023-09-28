# Use a minimal base image to reduce the image size
FROM ubuntu:20.04

# Set environment variables
ENV MAVENCONFIG=/var/maven/.m2
ENV M2_HOME=/opt/apache-maven-3.9.4
ENV PATH=$M2_HOME/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl lsb-release gnupg wget openjdk-17-jdk awscli && \
    rm -rf /var/lib/apt/lists/* \
    mkdir -p /var/maven/.m2 && chown 1000:1000 /var/maven/.m2

# Install Maven
RUN wget -q https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz -O /tmp/apache-maven-3.9.4-bin.tar.gz && \
    tar -xf /tmp/apache-maven-3.9.4-bin.tar.gz -C /opt/ && \
    rm /tmp/apache-maven-3.9.4-bin.tar.gz
