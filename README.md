# Borg server in docker container

This image provides a ready to use borg server with ssh enabled.

## Using image

~~~bash
docker run -it -v /local/borg/path:/borg -p 2222:2222 -e KEYS="ssh-rsa HDIEW[...]DE= \n ssh-rsa DJEIW[...]DE=" l4rs/borg:latest
~~~

The ssh daemon and all borg operations are running with UID and GID `4001` belonging to the bkp user inside the container.

## Doing backups:

For initilizing a new borg repository do the following from a client:

~~~bash
# export ssh options for borg client (ssh-key-file):
export BORG_RSH="ssh -i /path/to/ssh-key-file -l bkp -p 2222"
borg init -e=repokey docker-host.test.com:/borg/test
~~~