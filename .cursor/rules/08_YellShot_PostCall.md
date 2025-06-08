---
description: 
globs: 
alwaysApply: false
---
# 🔁 YellShot PRD – 04: Post-Call Workflow

## 🎯 Purpose
Handles what happens after a call completes: saving data, processing reactions, and messaging recipients.

---

## 📁 Audio Management

- Where files live in S3
- Naming conventions
- Cleanup policy (optional)
- Transcription steps if needed

---

## 📤 Recording & Archiving

- Save final `.mp3` to cloud (e.g., S3)
- Link recording to `message_id`
- Add timestamp, duration, and AI voice used

---

## 📥 Recipient Response

- If user consented:
  - Capture live reaction via Twilio
  - Store `response_recorded = true`
  - Upload `reaction_url`

---

## 📲 Reply SMS (Optional)

- Text recipient a link: “Reply anonymously”
- Include call reference ID
- Link opens on yellshot.com

---

## ✅ Closeout

- Update status to `closed`
- Trigger email to sender (optional): “Reaction received”