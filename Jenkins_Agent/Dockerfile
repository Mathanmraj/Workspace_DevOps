FROM jenkins-ansible-agent:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG TERRAFORM_VERSION=1.16.5

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    curl -fsSL \
      "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${arch}.zip" \
      -o /tmp/terraform.zip; \
    unzip /tmp/terraform.zip terraform -d /usr/local/bin; \
    chmod 755 /usr/local/bin/terraform; \
    rm /tmp/terraform.zip; \
    terraform version

USER jenkins
