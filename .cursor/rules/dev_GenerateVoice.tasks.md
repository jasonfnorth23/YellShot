---
description: 
globs: 
alwaysApply: false
---
# 🔊 Dev Tasks – Generate Voice via Cartesia AI

Tracks integration of Cartesia AI API to convert LLM response into expressive MP3 audio per persona.

---

## 🛠️ Cartesia Setup

- [ ] Create Cartesia AI account
- [ ] Retrieve API key and test key endpoint
- [ ] Confirm regional voice availability and latency

---

## 🔁 Voice ID Management

- [ ] Map each persona to Cartesia voice ID
- [ ] Store mapping in `VoiceAI.mdc`
- [ ] Confirm fallback voice for testing/dev

---

## 🔌 API Endpoint: `/generate-voice`

- [ ] Build secure HTTP API endpoint
- [ ] Input: `{ response_text, voice_id }`
- [ ] Output: `{ audio_url }`
- [ ] Store MP3 in S3 (`/calls/{call_id}/ai_message.mp3`)
- [ ] Return signed S3 URL in response

---

## 📦 S3 Integration

- [ ] Setup bucket and policy for audio files
- [ ] Add pre-signed URL logic
- [ ] Create retention policy (e.g., 30 days)

---

## 🧪 Testing

- [ ] Generate 5 sample messages across call types
- [ ] Validate MP3 output quality + emotional fidelity
- [ ] Measure average latency

---

## 🧠 References

- `06_YellShot_VoiceAI.mdc` – Voice ID assignments
- `09_YellShot_IntegrationEngine.mdc` – Call flow + audio handling
