# Description

Docker image with installed CLI tools: `ansible`, `aws`, `jinja2`, `kubectl` and `terraform`.


# DevOps tools

* Ansible   `2.7.9`
* awscli    `1.16.131`
* Jinja2    `2.10`
* kubectl   `v1.13.4`
* helm      `v2.13.0`
* Terraform `0.11.13`


# Tools

* bash (+ bash_completion)
* curl
* jq
* openssh-client
* openssl
* python3 (+ virtualenv)
* sshpass
* tar
* vim


# Basic usage

```
docker run --rm hajowieland/opsbox ansible --help
docker run --rm hajowieland/opsbox aws help
docker run --rm hajowieland/opsbox kubectl --help
```


# Advanced usage

```
docker run -ti -v ${HOME}/.opsbox -v ${PWD}:/opsbox itsvit/opsbox kubectl get pods --all-namespaces
docker run -ti -v ${HOME}/.opsbox -v ${PWD}:/opsbox itsvit/opsbox aws ec2 describe-instances --region eu-central-1
docker run -ti -v ${HOME}/.opsbox -v ${PWD}:/opsbox itsvit/opsbox ansible-playbook playbooks/describe-kubernetes-cluster.yml
```
:exclamation: __Important__
