#!/bin/sh

echo "change_permissions"
cd /opt/app
tar -zxvf package.tar.gz
chown -R vapor /opt/app
