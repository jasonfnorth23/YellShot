---
description: 
globs: 
alwaysApply: false
---
# 🖥️ Dev Tasks – CLI Scripts & Local Env Setup

Tracks command-line tools and environment prep for local testing and batch call generation.

---

## 🧰 CLI Tools

- [ ] `generate-response.js` – Takes persona, message, and recipient name → outputs LLM response
- [ ] `generate-voice.js` – Takes response text + voice ID → outputs MP3 from Cartesia
- [ ] `queue-call.js` – Takes number + audio URL → queues Twilio call

---

## 🧪 Batch Test Runner

- [ ] CLI: `test-call-flow.sh`
  - Calls all 3 scripts in order
  - Prints final result and S3 playback URL
  - Logs errors to `logs/`

---

## ⚙️ Local Env Setup

- [ ] Create `.env.example` with:
  - `LLM_HOST=http://localhost:11434`
  - `CARTESIA_API_KEY=sk-...`
  - `S3_BUCKET=yellshot-audio`
  - `TWILIO_SID=...`
  - `TWILIO_TOKEN=...`
  - `TWILIO_FROM_NUMBER=+1...`

- [ ] Add `.env` to `.gitignore`
- [ ] Add a `.bootstrap.sh` script to auto-start local stack (optional)

---

## 🧠 References

- Used for automation and offline iteration of `09_YellShot_IntegrationEngine.mdc`
