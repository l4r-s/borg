FROM alpine:3.9
LABEL MAINTAINER="Lars Bättig <me@l4rs.net>"

ARG USERID=4001
ARG GROUPID=4001


RUN apk upgrade --no-cache \
    && apk add --no-cache \
    alpine-sdk \
    tzdata \
    sshfs \
    python3 \
    python3-dev \
    openssl-dev \
    lz4-dev \
    acl-dev \
    openssh \
    bash \
    linux-headers \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade borgbackup


# create user
RUN  addgroup -g ${GROUPID} bkp \
        && adduser -u ${USERID} -D -G bkp bkp  \
        && mkdir -p /hom/bkp/.ssh  \
        && mkdir -p /home/bkp/run/ \
        && mkdir -p /borg

# copy stuff
COPY sshd_config /home/bkp/sshd_config
COPY entrypoint.sh /home/bkp/entrypoint.sh
COPY tests/id_rsa /home/bkp/.ssh/id_rsa

# fixing permissions
RUN chown bkp:bkp /home/bkp/ -R \
    && chown bkp:bkp /borg -R

USER bkp

EXPOSE 2222

VOLUME ["/borg"]

CMD ["/home/bkp/entrypoint.sh"]