---
description: 
globs: 
alwaysApply: false
---
## 🎯 Project Overview

YellShot.com is an anonymous voice-based message delivery platform. Users select a call type, choose an AI persona, write their message, and YellShot makes the call using AI voice + Twilio. The recipient hears the message, responds, and is optionally prompted to reply via a link.

---

## 🔄 End-to-End UX Click Path

1. **Visit Homepage** (`01_YellShot_PublicPage.mdc`)
   - User chooses call type → selects persona → enters message
   - Selects delivery tier ($5 / $20 / $50)
   - Enters email + phone
   - Pays via Stripe (Stripe Elements embedded)

2. **Payment Trigger** (`04_YellShot_PaymentTrigger.mdc`)
   - Message is autosaved as `pending_message`
   - Stripe PaymentIntent created
   - On payment success, webhook updates message to `payment_confirmed`

3. **Queue System** (`05_YellShot_QueueTrigger.mdc`)
   - Prioritizes calls by tier
   - Queue item created with `expires_at` SLA
   - Call marked `queued_for_delivery`

4. **Call Delivery** (`07_YellShot_CallDelivery.mdc`)
   - Initiates call via Twilio
   - Handles call status events (success, fail, no-answer)
   - Records audio + stores metadata

5. **Voice AI Experience** (`06_YellShot_VoiceAI.mdc`)
   - Persona speaks with intro, message, and follow-ups
   - Captures recipient response
   - Begins with a legal consent message:
     > "This call is being recorded for quality and verification purposes. By continuing, you agree to hear a confidential message from [Agency Name]. If you do not wish to proceed, you may hang up now."

6. **Post-Call Handling** (`08_YellShot_PostCall.mdc`)
   - Recording stored (S3)
   - If reply allowed, SMS sent to recipient
   - Status updated to `response_recorded` or `undelivered`
   - If recipient doesn't answer or declines:
     - SMS with callback link sent (expires in 10 days)
     - 1 retry attempted after 1 hour
     - Final fallback: message texted

7. **Admin Panel** (`03_YellShot_AdminPanel.mdc`)
   - View all calls, statuses, recordings, Stripe links
   - Manual overrides, retries, delete or archive

---

## 🧠 Project Structure / PRDs

| File                             | Description                                 |
|----------------------------------|---------------------------------------------|
| `00_YellShot_General.mdc`       | Master overview and constants               |
| `01_YellShot_PublicPage.mdc`    | Public call config + Stripe UI              |
| `02_YellShot_CallEngine.mdc`    | Core state transition engine                |
| `03_YellShot_AdminPanel.mdc`    | Admin dashboard for call management         |
| `04_YellShot_PaymentTrigger.mdc`| Stripe form submission + webhook sync       |
| `05_YellShot_QueueTrigger.mdc`  | Queue enqueuer logic based on tier          |
| `06_YellShot_VoiceAI.mdc`       | Persona scripting and voice logic           |
| `07_YellShot_CallDelivery.mdc`  | Twilio voice delivery and retries           |
| `08_YellShot_PostCall.mdc`      | Recording storage and reply link SMS        |

> `04_YellShot_QueueSystem.mdc` is deprecated.

---

## 🔧 Tech Stack & Core Architecture

YellShot.com uses a hybrid architecture that combines high-quality AI voice synthesis, open-source conversational logic, and scalable infrastructure to deliver theatrical phone calls with fictional personas.

---

### 🧠 Conversation Logic
- **LLM**: Self-hosted open-source LLM (e.g., Mixtral, LLaMA2, OpenChat)
- **Role**: Drives persona improvisation, identity checks, consent dialogue, “stir-the-pot” questions
- **Benefit**: Full character control, reduced cost vs. hosted LLMs

---

### 🔊 Voice Engine
- **TTS Provider**: Cartesia AI
- **Role**: Converts AI-generated dialogue into expressive MP3s
- **Reason**: Matches ElevenLabs quality at a fraction of the cost

---

### 📞 Call Delivery
- **Voice API**: Twilio Programmable Voice
- **Flow**:
  - Outbound call initiated
  - Confirm recipient identity
  - Ask for verbal consent
  - Play Cartesia-generated voice message
  - Ask for reply + follow-up/stir-the-pot question
  - Record and upload recipient's reaction
- **Optional**: Transcribe reactions with Whisper or AWS Transcribe

---

### 💳 Payments
- **Provider**: Stripe Elements + PaymentIntents
- **Frontend**: Embedded on-page (no redirects)
- **Functionality**: Supports delivery tiers and queues call post-payment

---

### 📁 Storage
- **Provider**: Amazon S3
- **Files Stored**:
  - `ai_message.mp3`
  - `reaction.mp3`
  - `final_call.mp3`
  - Logs and metadata

---

### 🛠️ Infrastructure
- **Frontend**: React / Next.js (or lightweight HTML/JS + Tailwind)
- **Backend**: Node.js (Express) or Supabase Edge Functions
- **Hosting**: Vercel or AWS Lightsail (or ECS if scaling)

---

## ☁️ Hosting & Deployment Notes

- **Frontend**: Vercel serves the static public site
- **Backend**: Supabase Edge Functions or Node.js (Express) handle API logic
- **Stripe**:
  - Stripe Elements (embedded on-page)
  - Uses PaymentIntents and secure webhooks
  - In dev, test webhooks with `ngrok` or `localtunnel`
- **Twilio**:
  - Requires verified phone numbers for production
  - Webhook requests must pass HMAC header verification
- **Storage**:
  - Amazon S3 stores call audio and call logs
- **Environment Notes**:
  - All services must enforce strict SLA timing
  - Failover and retry logic should respect delivery tier

---

## 🧩 Shared Constants

- `call_type` (enum) — selected by user (e.g., Breakup, Confession, Roast)
- `persona_id` — selected persona
- `agency_id` — inferred from persona or call type
- `tier` — pricing/delivery tier (int: 5, 20, 50)
- `status` — one of: `draft`, `queued`, `in_progress`, `completed`, `failed`
- `message` — max 500 characters

---

## ⚙️ Configuration

- Personas are dynamically filtered by `call_type`
- Calls are queued FIFO
- Higher tiers get priority in queue
- Messages support personalization (e.g., "Hi John")
- A "TEST" button lets users preview the AI voice before payment

---

## 📥 Reply Experience

- SMS reply includes:
  > "[Sender's Name or Someone Anonymous] has paid to send you a private message. Request callback at YellShot.com?ABC123"
- Clicking the link opens a page:
  - Informs user they have a message
  - Clicking a button triggers the call from the persona

---

## 🎧 Call Recording

- Entire call (AI + response) recorded as one file
- Sent via email to sender
- Stored in S3
- Only admin can access full recordings dashboard
- Max call length: 1 minute

---

## 🧠 AI Behavior

- Each persona has fallback logic if no response is received
- Fallback lines match tone (funny, weird, gentle, etc.)

---

## 🚫 Abuse Prevention

To prevent spamming a recipient:
- 2nd message: must wait 30 days after 1st
- 3rd message: must wait 60 days after 2nd
- 4th+ messages: must wait 90 days after prior

---

## 🔍 Moderation

- Messages run through AI moderation
- Blocks hate speech, abusive or explicit content

---

## 🎁 Promo Codes

- Stripe Promo Codes and Coupons will be supported
- Use cases:
  - Free credits
  - % or $ discounts
  - Limited-time campaigns

---

## 🧹 Redundancy Cleanup Notes

- Agency and persona mappings now exist in dedicated tables above.
- Avoid repeating call type breakdown in multiple sections unless relevant to a flow.
- General.mdc serves as the master reference doc — the others are modular PRDs by system.

---

## 📌 Strategy Notes

- All logic must be server-enforced (not just client-side)
- Delivery SLA is priority-driven — retry logic must honor it
- Keep frontend surreal but frictionless
- Backend must store full call event logs + Stripe receipts
