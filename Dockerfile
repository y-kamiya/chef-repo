FROM ubuntu

RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -L https://www.getchef.com/chef/install.sh | sudo bash
    
