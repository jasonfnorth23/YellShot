---
description: 
globs: 
alwaysApply: false
---
# 🧠 Dev Tasks – Bootstrap LLM for Persona Logic

Tracks setup and integration of self-hosted LLM used to generate persona-style messages before voice synthesis.

---

## 🛠️ Local LLM Setup

- [ ] Choose local LLM engine (e.g., Ollama, LM Studio, vLLM)
- [ ] Download and test Mixtral or OpenChat model
- [ ] Validate performance + startup time
- [ ] Add logging, retry, and health check endpoint

---

## 🧠 Persona Prompt Logic

- [ ] Create base system prompt template (e.g., "You are [Persona], speaking from [Agency]...")
- [ ] Add persona tone presets (e.g., detached, remorseful, savage)
- [ ] Store tone → prompt modifiers in `VoiceAI.mdc`
- [ ] Support injecting sender message + recipient name into prompt

---

## 🔌 API Endpoint: `/generate-response`

- [ ] Build secure HTTP API endpoint
- [ ] Input: `{ persona, message, recipient_name, tone }`
- [ ] Output: `{ response_text }`
- [ ] Add logging of inputs/outputs for QA
- [ ] Add latency timeout (10s max)

---

## 🧪 Testing

- [ ] Create test persona inputs (for 4-5 call types)
- [ ] Run batch tests and store example completions
- [ ] Validate tone alignment and emotional delivery

---

## 🧠 References

- `06_YellShot_VoiceAI.mdc` – Persona tone design
- `09_YellShot_IntegrationEngine.mdc` – Orchestration flow
