---
description: 
globs: 
alwaysApply: false
---
# ✅ Dev Tasks – Integration Engine

Tracks development tasks for the full orchestration pipeline (LLM → Voice → Call → Recording → Notification).

---

## 🧩 Core Flow – From Payment to Playback

### 1. Trigger on Payment
- [ ] Hook into Stripe webhook for `payment_intent.succeeded`
- [ ] Fetch order metadata (persona, message, call type, etc.)
- [ ] Call `/generate-response` with that data

---

### 2. Generate Persona Script
- [ ] Stand up endpoint `/generate-response`
- [ ] Inject system prompt per persona tone (from VoiceAI.mdc)
- [ ] Return `response_text` with character flavor

---

### 3. Generate Voice MP3 via Cartesia
- [ ] Build `/generate-voice` endpoint
- [ ] Map persona to voice ID
- [ ] Call Cartesia API with `response_text`
- [ ] Save resulting MP3 to S3 as `ai_message.mp3`

---

### 4. Queue the Twilio Call
- [ ] Build `/queue-call` endpoint
- [ ] Dynamically generate TwiML or `voice.xml` to play MP3 from S3
- [ ] Include:
  - Identity check
  - Consent statement
  - Message playback
  - Stir-the-pot question
  - Reaction recording (`reaction.mp3`)

---

### 5. Post-Call Handling
- [ ] Upload `reaction.mp3` to S3
- [ ] (Optional) Merge with `ai_message.mp3` into `final_call.mp3`
- [ ] Update DB with final call status

---

### 6. Notify Sender
- [ ] Generate secure playback link (tokenized URL)
- [ ] Send SMS/email to sender with link: “Hear Their Reaction”

---

## 🔐 Supporting Infrastructure
- [ ] Setup secure S3 buckets + pre-signed URLs
- [ ] Logging for each API stage
- [ ] Timeout/retry protection for Cartesia and Twilio

---

## 🧠 References
- `09_YellShot_IntegrationEngine.mdc` – Flow spec + API contracts
- `06_YellShot_VoiceAI.mdc` – Persona tones + voice ID mapping
- `07_YellShot_CallDelivery.mdc` – Twilio call logic + playback XML
