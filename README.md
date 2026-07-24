# 🩻 Project Autopsy

> Agentic DFIR pipeline — Velociraptor endpoint forensics, Wazuh detection, and Claude AI triage.

## 🔍 Description
Automated digital forensics and incident response for the homelab. When Wazuh
detects suspicious activity, Autopsy triggers targeted Velociraptor hunts on the
affected endpoint, collects forensic artifacts, and uses Claude to analyze
findings and produce an investigation report.

## 🏗️ Architecture
*(diagram coming in v0.2 — Wazuh alert → n8n → Velociraptor hunt → Claude analysis)*

## 🧰 Tech Stack
- Velociraptor 0.77.1 (endpoint forensics / hunting)
- Wazuh (detection & alerting)
- n8n (orchestration)
- Claude API (AI triage & reporting)
- Ubuntu Server / VMware homelab

## ✨ Features
- [ ] Velociraptor server + enrolled Linux agent
- [ ] Wazuh-triggered automated hunts
- [ ] AI-generated forensic reports

## 🗺️ Roadmap
| Version | Milestone | Status |
|---------|-----------|--------|
| v0.1 | Velociraptor server up, GUI reachable, agent enrolled | ✅ Complete |
| v0.2 | Wazuh alert → hunt trigger | ⏳ Planned |

## 📁 Project Structure
*(TBD)*

## ⚙️ Setup & Installation
*(v0.1 docs coming)*

## 🔬 Hunt Artifacts & VQL
*(TBD)*

## 🧪 Validation Case Study
Validation target: re-investigate the Tripwire "butter" incident
(T1136.001 account creation + T1070.003 log clearing) using forensic
artifacts instead of live detection.

## 🤖 AI Triage Agent
*(TBD — Claude analysis phase)*

## 🏠 Homelab Environment
*(TBD)*

## 🔐 Security Notes
Lab-only credentials; self-signed certs; isolated network.

## 👤 Author
Eliezer Fuentes — [GitHub](https://github.com/enak223) · [LinkedIn](https://www.linkedin.com/in/eliezerfuentes)

## 🪦 Quote
> *"Every contact leaves a trace."* — Edmond Locard
