# Use a minimal base image
FROM ubuntu:20.04

# Set one environment variable to avoid interactivity during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install packages, create user and directory, and set ownership in one RUN command
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl lsb-release gnupg wget openjdk-17-jdk awscli && \
    useradd -m ubuntu && \
    mkdir -p /var/maven/.m2 && chown ubuntu:ubuntu /var/maven/.m2 && \
    rm -rf /var/lib/apt/lists/*

# Set remaining environment variables
ENV MAVENCONFIG=/var/maven/.m2
ENV M2_HOME=/opt/apache-maven-3.9.4
ENV PATH=$M2_HOME/bin:$PATH

# Download and install Maven in one layer
RUN wget -q https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz -O /tmp/apache-maven-3.9.4-bin.tar.gz && \
    tar -xf /tmp/apache-maven-3.9.4-bin.tar.gz -C /opt/ && \
    rm /tmp/apache-maven-3.9.4-bin.tar.gz

# Switch to 'ubuntu' user
USER ubuntu
