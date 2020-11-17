#!/bin/bash
# Add the ppa repository for grafana
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
# Add the gpg key to install signed packages
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install grafana

systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service
#The default port for Grafana is 3000.
#The default login for Grafana is ‘admin’ and the default password is also ‘admin’
