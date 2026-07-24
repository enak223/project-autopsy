#!/usr/bin/env bash
# Project Autopsy — Velociraptor API reference calls (v0.2)
# Proven working 2026-07-24. API user: n8n-autopsy (roles: api,reader,investigator)
# Config: ~/velociraptor/api_client.yaml  |  API bind: 127.0.0.1:8001

CFG=~/velociraptor/api_client.yaml
CLIENT=C.3c3bbb15ad3ee0d4   # u-webserver (.139)

# 1. List enrolled clients (reader)
pyvelociraptor --config $CFG \
  "SELECT client_id, os_info.hostname AS hostname, last_seen_at FROM clients()"

# 2. Schedule a collection (investigator) -> returns flow_id F.xxxx
pyvelociraptor --config $CFG \
  "SELECT collect_client(client_id='$CLIENT', artifacts=['Generic.Client.Info'], env=dict()) AS collection FROM scope()"

# 3. Read collection results (reader) — replace FLOW_ID
# Valid columns: Hostname, OS, Architecture, Platform, PlatformVersion, KernelVersion, Fqdn, MACAddresses
pyvelociraptor --config $CFG \
  "SELECT Fqdn, Hostname, OS, Platform, PlatformVersion FROM source(client_id='$CLIENT', flow_id='FLOW_ID', artifact='Generic.Client.Info/BasicInformation')"
