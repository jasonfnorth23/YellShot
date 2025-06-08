---
description: 
globs: 
alwaysApply: false
---
# 🎭 Dev Tasks – Persona QA & Consistency Checks

Ensure each YellShot persona has distinct vocal traits, emotional tone, and matching improv logic.

---

## 🔊 Voice Consistency

- [ ] Generate Cartesia voice samples for each persona
- [ ] Validate:
  - Gender match
  - Emotional tone (e.g., “detached,” “savage,” “soft-spoken”)
  - Clarity and realism

---

## 🧠 Dialogue QA

- [ ] Generate sample LLM responses for each persona
- [ ] Confirm voice and logic match:
  - “Dr. Confession” = remorseful but articulate
  - “DJ Regret” = wild and irreverent
  - “Sister Sorry” = soft and uncertain
- [ ] Create prompt template for each and store in `VoiceAI.mdc`

---

## 🎧 Call Type Coverage

- [ ] Ensure at least 2 personas per call type (male/female)
- [ ] Map call types to tone presets
- [ ] Create a master persona QA table (optional)

---

## 🧠 References

- `06_YellShot_VoiceAI.mdc` – Persona tones and voice IDs
- `dev_BootstrapLLM.tasks.mdc` – Prompt logic for responses
