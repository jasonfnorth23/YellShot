---
description: 
globs: 
alwaysApply: false
---
# 🧠 YellShot PRD – 10: Voice Synthesis Server

## 🎯 Purpose

Handles text-to-speech (TTS) conversion for YellShot personas using the Cartesia AI voice API, returning a downloadable `.mp3` URL to be used in calls or playback.

---

## ⚙️ Endpoint: `/generate-voice`

- **Method:** POST  
- **Auth:** None (local dev only)  

**Request Body:**
```json
{
  "response_text": "Your message here.",
  "voice_id": "agent_farewell"
}
```

**Returns:**
```json
{
  "audio_url": "http://localhost:3000/calls/output.mp3"
}
```

---

## 🧩 Core Logic

1. **Receive POST payload**
   - Validate `response_text` and `voice_id`

2. **Generate MP3**
   - Use Cartesia API with mapped `voice_id`
   - Store audio as `calls/{timestamp}_{voice_id}.mp3`

3. **Serve MP3**
   - Host static files from `/calls/` folder
   - Return full `audio_url`

---

## 🗂️ Voice Config Map

Maps persona identifiers to Cartesia voice model IDs:

```js
const voiceMap = {
  "agent_farewell": "cartesia_m1",
  "doctor_detachment": "cartesia_m2",
  "sister_sorry": "cartesia_f1",
  "the_countess_of_contrition": "cartesia_f2"
  // ... add all persona mappings
};
```

---

## 📁 Folder Structure

```bash
voice-server/
├─ calls/              # Stored MP3s
├─ server.js           # Express app
├─ voiceMap.js         # Voice ID mapping
├─ .env                # Contains CARTESIA_API_KEY
```

---

## 🧪 Local Dev Notes

- Cartesia API should return a downloadable MP3 or audio stream
- Store all voice renders in `./calls` folder
- Serve `/calls/{filename}.mp3` via static route
- Use `PORT=3000`

---

## 🔒 Optional: Rate Limits & Logging

- Enforce per-IP or per-session rate limits
- Store voice render logs
- Add automatic cleanup of old audio files

