---
description: 
globs: 
alwaysApply: false
---
# 📞 Dev Tasks – Queue Call via Twilio

Handles outbound AI voice call delivery using Twilio Programmable Voice, with playback of Cartesia-generated MP3s and recording of the recipient's reaction.

---

## 🛠️ Twilio Setup

- [ ] Buy verified Twilio number (must support outbound voice)
- [ ] Enable voice calling for US + international (future-proofing)
- [ ] Create Twilio application + webhook routing

---

## 🔌 API Endpoint: `/queue-call`

- [ ] Build secure HTTP API endpoint
- [ ] Input: `{ to_number, audio_url, metadata }`
- [ ] Output: `{ call_id, status }`
- [ ] Save to DB with status: `queued`

---

## 🧾 TwiML Generation

- [ ] Generate dynamic TwiML or use `voice.xml` handler
- [ ] Playback logic:
  - Greet recipient, confirm identity
  - Ask for consent (“This call is recorded…”)
  - Play `ai_message.mp3`
  - Ask: “What would you say back?”
  - Stir-the-pot follow-up (optional)
  - Start recording

---

## 🎙️ Recording Setup

- [ ] Use `<Record>` TwiML to capture `reaction.mp3`
- [ ] Upload recording to S3 bucket under `/calls/{call_id}/reaction.mp3`
- [ ] Store duration, transcript (optional)

---

## 🔁 Retry Logic

- [ ] Handle call failures: no answer, rejected, busy
- [ ] Retry once per call (based on delivery tier)
- [ ] Update status: `delivered`, `failed`, `undelivered`

---

## 🧠 References

- `07_YellShot_CallDelivery.mdc` – Twilio flow details
- `09_YellShot_IntegrationEngine.mdc` – Trigger and orchestration logic
