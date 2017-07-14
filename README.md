# fffl-fastd-peers
Fastd peers of Freifunk Flensburg Gateways

For the gateway to be able to connect to the other gateways and nodes known in the network, you need to get a bunch of files with the public keys for these. For Freifunk Nord for example, this looks like this:

git clone https://github.com/freifunk-flensburg/fffl-fastd-peers /etc/fastd/vpn/peers
reload fastd without quitting:

killall -HUP fastd
if it says "no process found", its because you just installed it and it doesn't run, so just start it:

service fastd start

Regularly update the peers via cron.

nano /etc/fastd/reloadPeers.sh

////////////////////////////////////////////////////////////////////////
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
if [ "$revision_current" != "$revision_new" ]
then
 kill -HUP $(pidof fastd)
fi

/////////////////////////////////////////////////////////////////////

make the script executable:

chmod +x /etc/fastd/reloadPeers.sh

and add these lines in cron with

sudo crontab -e
# Regularly update the fastd peers
*/5 * * * * /etc/fastd/reloadPeers.sh
