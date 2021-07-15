#!/bin/bash

# Get Grafana Dashboards
# GRAFANA_TOKEN=
# GRAFANA_URL=

grafcurl() {
  curl -H "Authorization: Bearer ${GRAFANA_TOKEN}" $@
}
