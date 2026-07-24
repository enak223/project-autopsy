# Case Study: Silent Client Enrollment Failure

## Symptom
After migrating the Velociraptor server from a foreground process to a systemd
service, both the GUI and API reported **0 enrolled clients** — despite the
client on u-webserver (.139) running with no errors in its service status.

## Investigation (layer-by-layer isolation)
Ruled out, in order:
- **ACL roles** — the `info()` PermissionDenied [MACHINE_STATE] was expected
  behavior (that plugin requires admin-tier permission), not the cause.
- **Datastore path** — config pointed at persistent `/opt/velociraptor`; no
  stale-copy issue.
- **TLS/certs** — client config correctly expected the self-signed cert.

## Root Cause
Running the client in the foreground with `-v` revealed the truth:
`dial tcp 192.168.248.20:8000: connect: connection timed out`

The server's ufw firewall had no rule for the frontend port 8000. Packets from
the client were silently **dropped**.

Key tell: **timed out** (not **refused**). A refusal is instant and means
nothing is listening; a timeout means packets are being dropped — pointing at a
firewall, not a dead service. The server was listening correctly on `*:8000`.

## Fix

sudo ufw allow from 192.168.248.0/24 to any port 8000 proto tcp

Scoped to the lab subnet. API (8001) and GUI (8889) remain localhost-only,
reachable via SSH tunnel. Client re-enrolled automatically within ~1 minute,
retaining its original Client ID.

## Lesson
The earlier GUI sighting was against the foreground server, before the systemd
cutover. Once the service took over, the firewall gap isolated the client while
every surface symptom pointed elsewhere. Verify network reachability at the
transport layer before chasing application-level causes.
