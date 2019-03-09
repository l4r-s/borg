#!/bin/bash

image=$1
BORG_RSH="ssh -i /home/bkp/.ssh/id_rsa -l bkp -p 2222 -o StrictHostKeyChecking=no"
BORG_REPO="borgtest:/borg/testrepo"

function borgclient {
    cmd=$1
    docker run -it --rm --link borgtest:borgtest -e BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK="yes" -e BORG_REPO="$BORG_REPO" -e BORG_RSH="$BORG_RSH" $image $cmd
}
echo "starting borg server..."
docker run -d --name borgtest --rm -e KEYS="$(cat $(pwd)/tests/id_rsa.pub)" $image
echo "done"
echo 

echo "Init borg repo.."
borgclient "borg init -e=none"
echo "done"
echo 

echo "Making backup..."
name=$(date +"%Y-%m-%d_%H:%M:%S")
borgclient "borg create ::$name /home/bkp"
echo "done"
echo 

echo "Listing backups"
borgclient "borg list"
echo 

echo "Restoring..."
borgclient "borg extract ::$name"
echo

echo "Info"
borgclient "borg info"
echo

echo "done, all checks passed!"
docker rm -f borgtest