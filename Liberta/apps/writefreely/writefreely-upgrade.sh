#!/usr/bin/env bash

# Newer version to upgrade to:
WRITEFREELY_VERSION="0.16.0"

# Install locations.
# Writefreely's installation directory, no trailing slash:
INSTALL_DIR="/var/www/blog.liberta.vip"

# Prepare locations and clean up:
cd $(dirname "${INSTALL_DIR}")
rm -f writefreely-fresh.*
rm -rf "${INSTALL_DIR}".backup
mkdir -pv /root/writefreely-backups/${WRITEFREELY_VERSION}/

# Download and copy local config files into place:
wget https://github.com/writefreely/writefreely/releases/download/v${WRITEFREELY_VERSION}/writefreely_${WRITEFREELY_VERSION}_linux_amd64.tar.gz -O writefreely-fresh.tar.gz
tar xvf writefreely-fresh.tar.gz

cp -av "${INSTALL_DIR}"/keys        /root/writefreely-backups/${WRITEFREELY_VERSION}/
cp -av "${INSTALL_DIR}"/config.ini* /root/writefreely-backups/${WRITEFREELY_VERSION}/
cp -av "${INSTALL_DIR}"/keys        ./writefreely/
cp -av "${INSTALL_DIR}"/config.ini* ./writefreely/

# Stop service, backup, rename dir, correct permissions:
systemctl stop writefreely.service
mv -v "${INSTALL_DIR}"{,.backup-before-${WRITEFREELY_VERSION}}
mv -v writefreely "${INSTALL_DIR}"
chown -Rv www-data: "${INSTALL_DIR}"

# Finally upgrade software:
cd "${INSTALL_DIR}" && ./writefreely db migrate

# Start and health check:
systemctl start writefreely.service 
systemctl status writefreely.service 

echo "Done. Keys and config files are in /root/writefreely-backups/${WRITEFREELY_VERSION}/"
echo "Backup is in ${INSTALL_DIR}.backup-before-${WRITEFREELY_VERSION}/"

# GTHO:
exit 0

