---
description: 
globs: 
alwaysApply: false
---
# 🐞 Dev Tasks – Error Logging & Monitoring

Ensure system visibility across LLM, Cartesia, Twilio, and payment flows.

---

## 🧾 Logging System

- [ ] Create centralized logging middleware
- [ ] Log to file and console in dev
- [ ] In prod: send logs to CloudWatch, Loggly, or Supabase Logs

---

## 🔐 Sensitive Info

- [ ] Never log:
  - Phone numbers
  - Credit card info
  - API keys
- [ ] Mask PII in logs (e.g. “+1******4567”)

---

## 🚨 Critical Alerts

- [ ] Flag:
  - LLM timeout/failures
  - Cartesia voice gen failure
  - Twilio call errors
  - S3 upload failures
- [ ] Optional: Slack or email alert webhook for `ERROR` level logs

---

## 🧠 References

- Applies to all APIs defined in `09_YellShot_IntegrationEngine.mdc`
- Should log context from: `/generate-response`, `/generate-voice`, `/queue-call`
