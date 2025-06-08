---
description: 
globs: 
alwaysApply: false
---
# 🛠️ Dev Tasks – Admin & Debug Tools

Build internal tools to trigger calls, monitor call statuses, and troubleshoot failed deliveries.

---

## 🧪 Manual Call Trigger

- [ ] Admin interface to:
  - Pick persona
  - Enter message
  - Input test number
  - Run full LLM → Voice → Twilio chain

---

## 📊 Status Dashboard

- [ ] Table view of:
  - Message ID
  - Status: queued, delivered, failed
  - Timestamps for each stage
  - Call type / persona
  - MP3 file links (message + reaction)

---

## 🧹 Cleanup Tools

- [ ] Button to delete test records (MP3 + DB)
- [ ] Option to re-run flow with different config

---

## 🔐 Access Control

- [ ] Protect with simple login or IP whitelist
- [ ] Restrict playback to authorized devs

---

## 🧠 References

- Sits above logic from `dev_IntegrationEngine.tasks.mdc`
- Uses APIs from `09_YellShot_IntegrationEngine.mdc`
