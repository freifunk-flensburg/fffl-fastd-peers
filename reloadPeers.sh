#!/bin/sh

# hop into correct directory to avoid cron pwd sucks
cd $(dirname $0)

# function to get the current sha-1
getCurrentVersion() {
  git log --format=format:%H -1
}

# get sha-1 before pull
revision_current=$(getCurrentVersion)

git pull -q

# get sha-1 after pull
revision_new=$(getCurrentVersion)

# if sha-1 changed, make fastd reload the keys
if [ "$revision_old" != "$revision_new" ]
then
	kill -HUP $(pidof fastd)
fi
