# Use a minimal base image to reduce the image size
FROM ubuntu:23.10

# Set environment variables separately
ENV M2_HOME=/opt/apache-maven-3.9.4
ENV PATH=$M2_HOME/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Create a user group, user, and install required packages in a single RUN to reduce layers
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl lsb-release gnupg wget openjdk-17-jdk awscli && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz -O /tmp/apache-maven-3.9.4-bin.tar.gz && \
    tar -xf /tmp/apache-maven-3.9.4-bin.tar.gz -C /opt/ && \
    rm /tmp/apache-maven-3.9.4-bin.tar.gz

# Install Docker
RUN apt-get update && \
    apt-get install -y --no-install-recommends docker.io && \
    rm -rf /var/lib/apt/lists/*
