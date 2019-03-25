FROM alpine:3.8
ENV ANSIBLE_VERSION 2.7.9
ENV AWSCLI_VERSION 1.16.131
ENV HELM_VERSION v2.13.0
ENV JINJA2_VERSION 2.10
ENV KUBECTL_VERSION v1.13.4
ENV TERRAFORM_VERSION 0.11.13

RUN apk update \
    && apk add --no-cache  bash bash-completion coreutils curl gcc git \
    jq less libc6-compat libffi-dev make musl-dev openssl openssh-client \
    openssl-dev python3 python3-dev py3-virtualenv sshpass tar unzip vim && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/bash_completion.d/ /etc/profile.d/


# Upgrade pip
RUN pip3 install --upgrade pip

# Install kubectl
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    kubectl completion bash > /etc/bash_completion.d/kubectl.sh

# Intsall Terraform
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Ansible
RUN pip3 install ansible==${ANSIBLE_VERSION} Jinja2==${JINJA2_VERSION} && \
    rm -rf /root/.cache && \
    find / -type f -regex '.*\.py[co]' -delete

# Install aws cli bundle
RUN pip3 install awscli==${AWSCLI_VERSION} boto && \
    rm -rf /root/.cache && \
    find / -type f -regex '.*\.py[co]' -delete && \
    ln -s /usr/local/aws/bin/aws_bash_completer /etc/bash_completion.d/aws.sh && \
    ln -s /usr/local/aws/bin/aws_completer /usr/local/bin/

# Install helm
RUN wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm


COPY start.sh /start.sh

RUN chmod +x /start.sh && \
    mkdir /mnt/opsbox && \
    ln -s /mnt/opsbox/.aws /root/.aws && \
    ln -s /mnt/opsbox/.kube /root/.kube

WORKDIR /opsbox

VOLUME ["/opsbox", "/mnt/opsbox"]

ENTRYPOINT ["/start.sh"]
