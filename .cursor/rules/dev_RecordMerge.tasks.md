---
description: 
globs: 
alwaysApply: false
---
# 🎧 Dev Tasks – Record, Merge & Finalize Audio

Tracks tasks for recording recipient reaction and optionally merging it with the original AI message into a `final_call.mp3`.

---

## 🎙️ Capture Reaction

- [ ] Setup Twilio `<Record>` with:
  - 30s max duration (configurable)
  - End on silence or DTMF
  - Fallback prompt if no audio detected
- [ ] Store MP3 in S3 as `/calls/{call_id}/reaction.mp3`

---

## 🧪 Transcription (Optional)

- [ ] Add Whisper or AWS Transcribe support
- [ ] Store transcript in DB for future reply logic
- [ ] Add confidence threshold for review

---

## 🎚️ Merge Logic

- [ ] Use FFmpeg or Node module to merge:
  - `ai_message.mp3` (TTS)
  - `reaction.mp3` (recorded)
- [ ] Output: `final_call.mp3`
- [ ] Store in S3 under `/calls/{call_id}/final_call.mp3`

---

## 🔐 Secure Playback Link

- [ ] Generate signed S3 URL for sender
- [ ] Include in email/SMS CTA: “Hear Their Reaction”

---

## 🧠 References

- `08_YellShot_PostCall.mdc` – Audio handling logic
- `09_YellShot_IntegrationEngine.mdc` – Full orchestration context
