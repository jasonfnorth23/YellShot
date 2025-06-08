---
description: 
globs: 
alwaysApply: false
---
## 🎯 Project Overview

YellShot.com is an anonymous voice-based message delivery platform. Users select a call type, choose an AI persona, write their message, and YellShot makes the call using AI voice + Twilio. The recipient hears the message, responds, and is optionally prompted to reply via a link.

---

## 📞 Full AI Call Script Flow

1. **Intro**  
   “This is [Persona], calling from [Agency]. I have a confidential message for [Name].”

2. **Identity Check**  
   “Are you [Name]? If not, visit YellShot.com for more information. If yes, I have a message to deliver.”

3. **Consent Line**  
   “Ready? Let’s begin…”

4. **Message Delivery**  
   - AI voice delivers the sender's message.

5. **Prompt for Reaction**  
   “What would you say back — if you weren’t being recorded?”

6. **Stir the Pot**  
   - Follow-up prompt specific to the call type.

7. **Call Closure**  
   “To reply anonymously, click the link I just texted you.”  
   “Talk recklessly. Stay anonymous. Visit YellShot.com.”

---

## 🧠 AI Voice Persona Architecture

- Voice profiles match selected persona.
- Each persona has:
  - Name
  - Tone (e.g., calm, savage, funny)
  - Associated agency
- Voice must reflect persona tone throughout call.

---

## ⛓️ Call Queue & Backend Flow

1. User fills out form → Backend stores as `pending_message`
2. Stripe payment is initiated
3. On `payment_intent.succeeded`, Stripe webhook updates message to `queued`
4. Backend assigns persona voice + composes script
5. Call delivery logic (via Twilio):
   - AI voice script is synthesized
   - Phone call placed to recipient
   - AI delivers call flow above
   - Reaction is recorded and linked to original message
6. Final call status marked as `completed` or `failed` in admin panel

---

## 🧪 Testing Requirements

- Twilio voice AI reads custom message
- Fallback script triggered on Twilio error
- Call recording saved + linked
- Confirm response and follow-up prompts function per call type

---

## 🔐 Privacy Considerations

- Caller name is never revealed
- Consent flow is implied, not stated as recorded
- Recording accessible only to sender (via admin review)

---

