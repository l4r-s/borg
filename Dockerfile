FROM debian:sid
MAINTAINER Lars Bättig <me@l4rs.net>

ARG USERID=2000

# install openssh-server and borg
RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install openssh-server borgbackup bash

# create user
RUN  useradd -u ${USERID} -m -U bkp && \ 
        mkdir -p /hom/bkp/.ssh && \
        mkdir -p /home/bkp/run/

# copy stuff
COPY sshd_config /home/bkp/sshd_config
COPY entrypoint.sh /home/bkp/entrypoint.sh

# fixing permissions
RUN chown bkp:bkp /home/bkp/ -R

USER bkp

EXPOSE 2222

VOLUME ["/borg"]

ENTRYPOINT ["/entrypoint.sh"]