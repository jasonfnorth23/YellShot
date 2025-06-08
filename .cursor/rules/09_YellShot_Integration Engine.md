# 🔀 YellShot PRD – 09: Integration Engine

## 🎯 Purpose

Coordinates the end-to-end flow once a user completes payment:
1. Generates character-specific dialog via LLM
2. Sends dialog to Cartesia AI for TTS
3. Stores resulting MP3 in S3
4. Queues a Twilio call for delivery
5. Updates call status and links to final recording

---

## 🧩 Orchestration Flow

### Trigger: Payment Success (`delivered` from Stripe webhook)

1. **Extract Configuration:**
   - Call type
   - Persona
   - User message
   - Delivery tier

2. **Generate Persona Script**
   - Endpoint: `POST /generate-response`
   - Input: JSON with persona name, tone, message, recipient info
   - Output: Character-enhanced response text

3. **Generate Voice File**
   - Endpoint: `POST /generate-voice`
   - Input: Response text + Cartesia voice ID
   - Output: `ai_message.mp3` stored in S3

4. **Initiate Twilio Call**
   - Prepare TwiML or dynamic `voice.xml` that plays `ai_message.mp3`
   - Handle:
     - Identity confirmation
     - Consent prompt
     - Message delivery
     - Stir-the-pot follow-up
     - Reaction recording

5. **Record Outcome**
   - Save call status to DB
   - Upload `reaction.mp3` to S3
   - Combine into `final_call.mp3` (optional)

6. **Notify Sender**
   - Send email/SMS with “Hear Their Reaction” link

---

## 🔗 API Contracts

### `/generate-response`
- **Input**:

```json
{
  "persona": "Doctor Detachment",
  "message": "I need space to grow. Please understand.",
  "recipient_name": "Marty",
  "tone": "detached"
}

Output:

{
  "response_text": "Marty, this is difficult to say... but it’s time I move on. I wish you clarity and calm."
}

/generate-voice
Input:

{
  "response_text": "Marty, this is difficult to say...",
  "voice_id": "detachment_male_01"
}

Output:
{
  "audio_url": "https://s3.amazonaws.com/yellshot/audio/ai_message.mp3"
}

/queue-call

Input:
{
  "to_number": "+15551234567",
  "audio_url": "https://s3.amazonaws.com/yellshot/audio/ai_message.mp3",
  "metadata": {
    "call_type": "Breakup",
    "persona": "Doctor Detachment",
    "delivery_tier": "standard"
  }
}

Output:
{
  "call_id": "call_abcdef123456",
  "status": "queued"
}

---
## 🧠 Notes
- Persona-to-voice-ID mappings live in 06_YellShot_VoiceAI.mdc
- Final audio files stored in S3 under /calls/{call_id}/
- Call logic and Twilio XML managed in 07_YellShot_CallDelivery.mdc
- Payment trigger initiates this flow as detailed in 04_YellShot_PaymentTrigger.mdc

---

### ✅ 2. Cross-Reference Lines for Other MDCs

Add this line at the bottom of the relevant MDCs:

#### In `04_YellShot_PaymentTrigger.mdc`

→ On payment success, trigger orchestration flow defined in 09_YellShot_IntegrationEngine.mdc

#### In `05_YellShot_QueueTrigger.mdc`

→ QueueTrigger consumes results from generate-response and generate-voice endpoints (see 09_YellShot_IntegrationEngine.mdc)

#### In `06_YellShot_VoiceAI.mdc`

→ Voice synthesis is triggered as part of integration engine (see 09_YellShot_IntegrationEngine.mdc)

#### In `07_YellShot_CallDelivery.mdc`

→ Call initiation is orchestrated from upstream logic in 09_YellShot_IntegrationEngine.mdc

#### In `08_YellShot_PostCall.mdc`

→ Final file handling and reaction recording referenced in 09_YellShot_IntegrationEngine.mdc

