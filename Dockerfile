FROM alpine:3.9
MAINTAINER Lars Bättig <me@l4rs.net>

ARG USERID=4001
ARG GROUPID=4001

RUN apk add --no-cache openssh borgbackup bash

# create user
RUN  addgroup -g ${GROUPID} bkp && \
        adduser -u ${USERID} -D -G bkp bkp && \ 
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

ENTRYPOINT ["/home/bkp/entrypoint.sh"]