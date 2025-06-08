---
description: 
globs: 
alwaysApply: false
---

# 🛠️ YellShot.com – Full Product Requirements Document (PRD)

PRD Contents
Area	Status
✍️ Product Concept	✅ Fully Defined
🎭 Call Types + Personas	✅ 10 call types mapped to unique personas + agencies
🧠 Voice Script Flow	✅ Intro → Message → Response → Stir-the-pot → CTA
🧾 Payment Flow (Stripe)	✅ Embedded Stripe Elements flow w/ tiers, metadata, webhook
📥 Message Queue Logic	✅ Pending message storage → webhook → paid → queue
🗃 Database Schema	✅ pending_messages and call_logs tables fully defined
🔁 Webhook + Call Handling	✅ Complete call queue process + retry logic
🧰 Admin Panel Requirements	✅ Full table of fields, actions, status tracking
💬 Prompt Design Tables	✅ Response + Stir-the-pot prompts per call type
🧭 UI Wireframe Reference	✅ Screenshot and annotated section-by-section breakdown
🔐 Legal/Compliance Notes	✅ Stripe/PCI notes + optional abuse handling in post-MVP
🔜 Future Features Flagged	✅ Reply threads, voice clones, persona builder, etc.

---

## 🎯 Project Overview

YellShot.com is an anonymous voice-based message delivery platform. Users select a call type, choose an AI persona, write their message, and YellShot makes the call using AI voice + Twilio. The recipient hears the message, responds, and is optionally prompted to reply via a link.

---

## 🧑‍💻 MVP Scope Summary

- Web app with a single-page public interface (home)
- Embedded Stripe Elements payment flow
- Admin dashboard with logs + call management
- AI-driven voice calls via Twilio
- Recording of calls with recipient reaction

---

## 🧑‍🤝‍🧑 User Roles

| Role      | Capabilities |
|-----------|--------------|
| Sender    | Compose message, choose persona, pay, receive reply |
| Recipient | Listen, speak response, optionally reply via SMS |
| Admin     | (Phase 2) Moderate, manage personas, flag abuse |


---

## 🧱 Core Features

### 1. Message Creation Flow
- User selects a persona.
- User types custom message.
- User enters recipient name and phone number.
- Optional: preview voice.
- Confirm & pay (if monetized).

### 2. AI Call Delivery
- Twilio places outbound call.
- AI introduces itself:  
  _“This is [Persona] from [Agency Name]. I have a confidential message for [Name]...”_
- Verbal confirmation from recipient.
- AI delivers the message.
- Prompts:  
  > “What’s your response?”  
  > “Why do you think they sent this?”

### 3. Call Recording
- Records recipient’s reply.
- Uploads to cloud (S3).
- Link sent to sender to hear it.

### 4. Personas & Agencies (MVP Set)

| Persona         | Style            | Agency Name                  |
|-----------------|------------------|------------------------------|
| Dr. Confession  | Soft, remorseful | The Institute of Unfinished Business |
| Ms. Closure     | Calm, surgical   | The Bureau of Second Chances |
| DJ Regret       | Savage, mocking  | The Hotline of Petty Reckonings |

- Each persona has:
  - Voice tone
  - Agency name
  - Intro script

### 5. Post-call SMS Closer + CTA

> “Thank you for your response.  
> If you’d like to reply anonymously, I just texted you a link.  
> **Let AI make the call.**  
> Visit **YellShot.com**.”

---

## 📞 YellShot Call Types, Personas, and Agencies

| **Call Type**                     | **Available Personas**                                                                 | **Agency / Organization**                          |
|----------------------------------|-----------------------------------------------------------------------------------------|----------------------------------------------------|
| **1. Breakup or Goodbye**        | Ms. Closure, Mr. Monday, Captain Cutdeep, Reverend Petty, Dr. Confession               | The Bureau of Second Chances, The Division of Professional Farewells, The Naval Authority of Necessary Pain, The Church of Consequences, The Institute of Unfinished Business |
| **2. Confession or Apology**     | Dr. Confession, Ms. Closure, Sister Static                                              | The Institute of Unfinished Business, The Bureau of Second Chances, The Hotline of Lost Frequencies |
| **3. Roast or Savage Burn**      | Reverend Petty, Major Shade, Captain Cutdeep, Ms. Vengeance                             | The Church of Consequences, The Department of Disrespect, The Naval Authority of Necessary Pain, The Archive of Grudges |
| **4. Petty Grievance**           | Major Shade, Ms. Vengeance, Vice Principal Pain, Reverend Petty                         | The Department of Disrespect, The Archive of Grudges, The Office of Emotional Compliance, The Church of Consequences |
| **5. Flirty Confession / Crush** | Agent Heartthrob, Dr. Burnlove, Captain Candlelight                                     | The Office of Forbidden Longing, The Institute of Flaming Truth, The Ministry of Maximum Celebration |
| **6. Birthday / Celebration**    | Captain Candlelight, Agent Heartthrob, Ms. Vengeance (sarcastic), Dr. Burnlove          | The Ministry of Maximum Celebration, The Office of Forbidden Longing, The Archive of Grudges, The Institute of Flaming Truth |
| **7. Weird or Surreal**          | Sister Static, The Oracle of Broken TVs, Agent Echo                                     | The Hotline of Lost Frequencies, The Signal Cathedral, The Department of Cold Truths |
| **8. Gratitude / Encouragement** | Dr. Confession, Captain Candlelight, Agent Heartthrob                                   | The Institute of Unfinished Business, The Ministry of Maximum Celebration, The Office of Forbidden Longing |
| **9. Revenge Message**           | Ms. Vengeance, Reverend Petty, Major Shade, Captain Cutdeep                             | The Archive of Grudges, The Church of Consequences, The Department of Disrespect, The Naval Authority of Necessary Pain |
| **10. Custom Freestyle**         | All personas available                                                                  | User selects any persona and agency pairing        |

---

## 🎭 Persona Directory

| **Name**           | **Tone / Style**                    |
|--------------------|-------------------------------------|
| Ms. Closure         | Calm, surgical                      |
| Dr. Confession      | Soft-spoken regret                  |
| Reverend Petty      | Holy fire & hilarious burns         |
| Major Shade         | Military-grade sarcasm              |
| Dr. Burnlove        | Sexy, cruel genius                  |
| Captain Cutdeep     | Brutal, precise                     |
| Mr. Monday          | Cold, corporate HR                  |
| Ms. Vengeance       | Femme fatale with receipts          |
| Captain Candlelight | Birthday cheer & chaos              |


---
## 📞 AI Call Script Flow

Each AI call follows a surreal, semi-bureaucratic format delivered by a fictional persona:

---

### 1. Intro + Identity Check

> “Hello, this is **[Persona Name]**, calling from the **[Agency Name]**.  
> I have a confidential message for **[Recipient First Name]**.  
> Is this **[Recipient First Name]**?”

- If **No**:  
  > “Understood. If this message reaches them later, they can visit **YellShot.com** for more information.  
  > Have a curious day.” [Call ends]

- If **Yes**, continue:

---

### 2. Message Delivery

> “Alright. Here is your message.”  
> *[Message from sender is read here by the persona]*

---

### 3. Response Prompt

> “What’s your response to this message?”

---

### 4. Stir-the-Pot Follow-Up

> “Why do you think they sent this now?”  
_(alternates by persona — e.g., “Do you think they’re finally over it?” or “Would you ever say it back?”)_

---

### 5. Closing + CTA

> “Thank you for your response.  
> If you’d like to reply anonymously, I just texted you a link.  
> **Let AI make the call.**  
> Visit **YellShot.com**.”

---

## 💸 Monetization

- **$5 – Standard Call**  
  - Message delivered within 4-8 hours.
  - AI persona delivers message.
  - Recording sent to sender when complete.

- **$20 – Expedited Call**  
  - Message delivered within 1 hour.
  - Includes SMS confirmation when call is complete.

- **$50 – Front of the Line**  
  - Message delivered ASAP (within minutes).
  - Guaranteed top priority in queue.
  - AI adds extra flair and a second follow-up question.
  - Recipient receives reply link via SMS.

---

## 🧾 Stripe Payment Flow

### Why Single Page?

Avoiding page redirects keeps emotion and engagement high. All user input and payment are handled on one screen using **Stripe Elements**.

### Delivery Speed / Pricing

- $5 → Delivered in 4–8 hours  
- $20 → Guaranteed within 1 hour  
- $50 → First in line (priority)

### Stripe Elements Setup

- Card fields embedded directly
- Stripe metadata includes:
  - `call_type`, `persona`, `message_id`, `tier`

---

## ⛓️ Queue & Backend Flow

1. **User fills out form** → Draft `pending_message` record saved
2. **User pays via Stripe** (client-side initiates PaymentIntent)
3. **Stripe Webhook fires** → Confirms payment
4. **Backend updates message status to “queued”**
5. **Call gets executed via Twilio**  
   - Records delivery + response  
   - Logs in admin panel

### Edge Case: User closes tab before payment confirms
- Draft is saved with `status = pending`
- If no webhook is received within X mins, auto-expire message

---

## 🧮 Admin Dashboard (Auth Required)

| Field              | Description                                      |
|-------------------|--------------------------------------------------|
| Message ID         | Unique record ID                                |
| Call Type          | From user selection                             |
| Persona            | Voice selected                                  |
| Status             | Pending / Queued / Success / Failed             |
| Audio File         | Link to call + response recording               |
| Timestamp          | Date created / sent                             |
| Delivery Tier      | $5 / $20 / $50                                  |
| Phone Number       | Destination number                              |
| Sender Name        | Captured for admin use only                     |
| Sender Email       | Optional — for refund or follow-up              |
| Stripe Session     | View link to verify transaction                 |

---

## 🧰 UI Reference: YellShot Single-Page Checkout

### Wireframe Screenshot

![YellShot Wireframe – Page Layout](mdc:YellShot.com-Page%201.png)

### Section-by-Section Breakdown

1. **Header + Tagline**  
   - “Let AI make the call.”  
   - “Breakups. Confessions. Roasts. Birthday chaos…”

2. **Step 1 – Call Config**  
   - Dropdown: Call Type  
   - Dropdown: Persona (filtered by type)  
   - Textarea: 500-char message

3. **Step 2 – Delivery Tier**
   - Radio buttons with:
     - $5 — 4–8 hrs
     - $20 — 1 hr guaranteed
     - $50 — First in Line
   - Info: FIFO queue notice, “Pay more to skip the line”

4. **Step 3 - Payment**  
   - Email + Stripe Elements  
   - Button: “Pay & Send YellShot!”

5. **Confirmation**  
   - Visual confirmation  
   - No redirect

---

---

### 🧠 Developer Notes for Implementation

- This UI is tightly coupled with:
  - Stripe Elements for in-page payment
  - Dynamic persona filtering based on call type
  - Pre-payment validation of message + phone input
  - Draft storage in backend (`pending_message`) before payment is submitted
- Upon clicking "Pay & Send YellShot!":
  - A PaymentIntent is created server-side
  - Client confirms payment via Elements
  - On success, the call is queued and user sees a visual confirmation

---

### ⛔ Post-Payment Redirect

There is **no redirect to another page.**  
All confirmations, errors, and visual feedback happen within the same layout to maintain flow and emotion.

---

## 🗂️ Table 1: Response Prompts

| Call Type           | Response Prompts |
|---------------------|------------------|
| Breakup/Goodbye     | “What do you wish you had said?”<br>“Do you want them back?”<br>“What’s your version of what happened?” |
| Roast / Insult      | “How do you *really* feel about them?”<br>“Want to clap back?”<br>“Was that fair or foul?” |
| Confession / Apology| “Do you forgive them?”<br>“What do they not understand?”<br>“Would you ever talk again?” |
| Love / Flirt        | “Do you feel the same?”<br>“What do you want to say back?”<br>“Is this cute or cringe?” |
| Birthday / Milestone| “Want to wish them back?”<br>“What’s your weirdest birthday memory?”<br>“What gift do they deserve?” |
| Petty Grudge        | “You mad or nah?”<br>“Petty... or justified?”<br>“What would *you* say if you had the mic?” |
| Closure / Ghosting  | “Why do you think they ghosted?”<br>“Would you even reply?”<br>“How does hearing this feel?” |
| Parenting           | “Are they right?”<br>“Anything you'd say if they were listening?”<br>“Do you regret anything?” |
| Roommate Conflict   | “What’s the real issue?”<br>“Would you ever live with them again?”<br>“What should they know?” |
| Custom              | “You got something to say?”<br>“Reply or walk away?”<br>“Mic's open if you want it.” |

---

## 🧂 Table 2: Stir the Pot Prompts

| Call Type           | Stir-the-Pot Questions |
|---------------------|------------------------|
| Breakup/Goodbye     | “Would you take them back if they begged?”<br>“What’s one thing they never understood?”<br>“Who was more to blame?” |
| Roast / Insult      | “Wanna name names?”<br>“What's their biggest flaw?”<br>“Would you roast them back?” |
| Confession / Apology| “Have you made peace with it?”<br>“What do they owe you?”<br>“Would you meet face to face?” |
| Love / Flirt        | “Do you feel butterflies or hives?”<br>“Would you date them?”<br>“What would you text them right now?” |
| Birthday / Milestone| “Would you show up to their party?”<br>“Best gift they’ve ever given?”<br>“What song reminds you of them?” |
| Petty Grudge        | “How long you been mad?”<br>“Wanna escalate this?”<br>“Did they deserve worse?” |
| Closure / Ghosting  | “If they texted now, would you answer?”<br>“What’s something you never got to say?”<br>“What do you wish they knew?” |
| Parenting           | “Would you raise your kids the same way?”<br>“Do you see yourself in them?”<br>“Is there a thank-you you never said?” |
| Roommate Conflict   | “What was the final straw?”<br>“Who was the better roommate?”<br>“Ever consider revenge?” |
| Custom              | “Want to keep this going?”<br>“Is this war or peace?”<br>“What’s your next move?” |

---

## 🧪 Tech Stack

| Layer        | Tool/Service |
|--------------|--------------|
| Frontend     | React or Vanilla JS |
| Backend      | Node.js or Python (FastAPI) |
| Voice AI     | ElevenLabs / Play.ht / Amazon Polly |
| Telephony    | Twilio |
| Database     | Firebase / Supabase / PostgreSQL |
| Storage      | AWS S3 |
| Hosting      | Vercel / Netlify / AWS Lightsail |

---

