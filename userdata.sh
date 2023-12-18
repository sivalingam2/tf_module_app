#!/bin/bash

yum install ansible python3.11-pip.noarch -y &>>/opt/userdata.log
pip3.11 install botocore boto3 &>>/opt/userdata.log
ansible-pull -i localhost, -U https://github.com/sivalingam2/ansible_project.git main.yml -e component=${component} -e env=${env} &>>/opt/userdata.log