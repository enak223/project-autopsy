# Case Study: Wiring n8n to Velociraptor via a Least-Privilege SSH Bridge

## Goal
Let n8n (in Docker) trigger Velociraptor collections without giving the
container broad access, and without exposing the gRPC API to the LAN.

## Design
n8n has no gRPC client and the container lacks Python, and Velociraptor's
only sanctioned automation path is gRPC-with-certificate (its REST API needs
a browser OAuth2 flow — unsuitable for automation). Solution: n8n SSHes to the
host and runs a wrapper that makes the gRPC call via pyvelociraptor.

Least privilege enforced at every layer:
- API user `n8n-autopsy` scoped to `api,reader,investigator` (no admin).
- Dedicated SSH key locked in authorized_keys with a forced command
  (`command="..."`, `no-pty`, no forwarding) — the key can ONLY trigger a
  collection, not open a shell.
- API bound 0.0.0.0 but firewalled: 8001 and 22 reachable only from the
  docker soc-net range (172.18.0.0/16); GUI stays localhost-only.

## Debugging war stories
1. **Client showed 0 enrolled** — root cause was ufw missing a rule for the
   frontend port 8000 (timeout, not refused = dropped packets = firewall).
2. **n8n "Unsupported key format"** — ed25519 keys aren't parsed reliably by
   n8n's ssh2 lib. Fixed by regenerating as RSA-4096 in PEM format AND pasting
   via n8n expression mode (backticks) to preserve newlines the field mangles.
3. **authorized_keys silently emptied** — a `grep pattern > same_file` self
   redirect truncated the file before reading. Key auth failed, SSH fell back
   to password. Rebuilt the entry; lesson: never redirect into the file you
   read.

## Result
Manual n8n trigger -> Velociraptor collection on the target host, returning a
flow_id as JSON. Survives full reboot (systemd services + docker restart
policies). Foundation for v0.2 Wazuh-alert-driven hunts.
