#!/bin/bash
#last release 1.0.0-rc.0
#release 0.18.1
NODE_EXPORTER_VERSION="1.0.0-rc.0"
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin

# create user
useradd --no-create-home -rs  /bin/false node_exporter

chown node_exporter:node_exporter /usr/local/bin/node_exporter

echo '[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/node_exporter.service

# enable node_exporter in systemctl
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
"

echo "To test if the metrics are being exported use:
      curl http://localhost:9100/metrics
"
