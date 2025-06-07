---
description: 
globs: 
alwaysApply: false
---
# 🧪 Dev Tasks – Test Call Flow (End-to-End QA)

Tracks tasks for validating full outbound call flow from message creation to reaction recording and playback link delivery.

---

## ✅ Test Data & Fixtures

- [ ] Create mock user inputs:
  - Multiple call types (breakup, roast, apology, etc.)
  - Multiple personas (male/female)
- [ ] Test Twilio with developer test number
- [ ] Include fake recipient names and phone numbers

---

## 🔁 E2E Flow Tests

- [ ] Trigger Stripe payment event manually (dev hook)
- [ ] Ensure LLM responds with correct tone
- [ ] Validate Cartesia voice matches persona
- [ ] Confirm Twilio initiates call
- [ ] Verify:
  - Consent prompt is audible
  - Message is played fully
  - Reaction is recorded
  - S3 URLs are generated
- [ ] Confirm final link is delivered to sender

---

## 🔊 Audio QA

- [ ] Listen to `ai_message.mp3` for tone accuracy
- [ ] Listen to `reaction.mp3` for clarity and engagement
- [ ] Listen to `final_call.mp3` for correct merge order

---

## 🧠 References

- `09_YellShot_IntegrationEngine.mdc`
- `dev_IntegrationEngine.tasks.mdc`
