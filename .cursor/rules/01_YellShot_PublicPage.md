---
description: 
globs: 
alwaysApply: false
---
## 🧑‍💻 MVP Scope Summary

- Single-page public interface for users to configure and pay for their YellShot call  
- Embedded Stripe Elements payment form (no page redirects)  
- Fields for call type, persona, message, and delivery speed tier  
- Payment triggers call queue after backend confirmation  

---

## 📄 How the Public Page Works

The public-facing page allows a user to:  
1. Choose a **Call Type** (e.g., Breakup, Roast, Confession)  
2. Pick a **Persona** filtered by call type  
3. Write a **custom message** (up to 500 characters)  
4. Select a **delivery speed tier** ($5 / $20 / $50)  
5. Pay via embedded **Stripe Elements form**  
6. On successful payment, message is submitted to queue and user sees confirmation  

All form data is autosaved to the backend as a `pending_message` **before** payment begins.

---

## 🧭 Orchestration Flow

- When APIs are triggered
- Progress UI flow
- Error fallback UI

---

## 📋 Form Field Definitions

| Field              | Type                | Notes                                      |
|-------------------|---------------------|--------------------------------------------|
| Call Type          | Dropdown            | Filters persona options                    |
| Persona            | Dropdown            | Filtered by call type                      |
| Message            | Textarea            | 500 character limit, profanity filtered    |
| Delivery Speed     | Radio buttons       | $5, $20, $50 tiers                         |
| Email              | Text input          | Required for support and receipts          |
| Credit Card Fields | Stripe CardElement  | Secure + PCI compliant                     |
| Phone Number        | Text input          | E.164 format required (e.g. +15555555555)  |

---

## ✅ Form Validation & Autosave

- All fields are required before enabling payment
- Message is profanity filtered and capped at 500 characters


- Autosave behavior:  
  - Form autosaves to backend on field blur  
  - If payment fails, user data is not lost  

---

## 🕒 Quiet Hours Tier Restrictions – Public Page MDC

---

### 🎯 Purpose

Limit late-night delivery for Free and Standard tier, while allowing Expedited and Front of the Line tiers to bypass restrictions and deliver immediately.

---

### 🕰️ Quiet Hours Definition

- Quiet Hours = **10:00 PM – 7:00 AM (recipient’s local time)**  
- Recipient local time is estimated by:
  - Phone number region via Twilio Lookup
  - (Optional) User-submitted region

---

### 🛒 Tier Options Behavior

| Tier             | After-Hours Status        |
|------------------|---------------------------|
| Free             | Delayed until 7:00 AM     |
| Standard         | Delayed until 7:00 AM     |
| Expedited ($20)  | Delivered immediately     |
| Front of Line ($50) | Delivered immediately  |

---

### 💬 Display Logic at Checkout

- If current time in recipient's region is **within Quiet Hours**:

#### For Free / Standard:
> “This message will be delivered after 7:00 AM in the recipient’s timezone.”

#### For Expedited / Front of Line:
> “This message will be delivered immediately — even during quiet hours.”

---

### 🧠 Optional UX Enhancements

- Disable selection of Free/Standard tiers during quiet hours *unless* user accepts delay
- Highlight Expedited/Front of Line as "Urgent Night Delivery" options

---

## 💳 Stripe Elements Integration

- Stripe Elements embedded inline — no redirect  
- On “Pay & Send YellShot!” click:  
  1. Backend creates `PaymentIntent` with `pending_message_id`  
  2. Client confirms via `stripe.confirmCardPayment`  
  3. Stripe webhook triggers queue processing

**Stripe Metadata includes:**  
- `call_type`  
- `persona`  
- `message_id`  
- `delivery_tier`  
- `phone_number`  
- `email`

---

## 💸 Delivery Tiers

All call requests are placed in a queue and processed on a FIFO basis (first in, first out).  
**Pay more to skip the line.**

| One-Time Fee | Tier Name          | Call Placed Within     |
|--------------|--------------------|-------------------------|
| $5           | Standard Call       | 4–8 hours              |
| $20          | Expedited Call      | 1 hour                 |
| $50          | Front of the Line   | A few minutes (priority)|

Notes:
- Tier affects queue priority
- Backend enforces timing thresholds
- Tier is stored as: `5`, `20`, or `50`

---

## 📦 Post-Payment Flow

- Stripe webhook confirms successful payment  
- Backend marks message as `paid`  
- Enters delivery queue based on tier  
- User sees success message: “Your YellShot is locked and loaded.”  
- **No page redirect** — UI confirms inline  
- Backend links Stripe `PaymentIntent` to `pending_message`
- Backend validates and reattaches metadata (e.g., if tab closed)
- Twilio call is queued by backend once all metadata is confirmed

---

## 🧰 UI Reference: YellShot Single-Page Checkout

### 📸 Wireframe Screenshot

![YellShot Wireframe – Page Layout](mdc:YellShot.com-Page%201.png)

---

## 🧭 Section-by-Section Breakdown

1. **Header + Tagline**  
   - Logo and title  
   - Tagline: “Let AI make the call.”  
   - Subtext: “Breakups. Confessions. Roasts. Birthday chaos…”

2. **Step 1 – Call Configuration**  
   - Dropdown: Call Type (filters persona list)  
   - Dropdown: Persona (based on selected type)  
   - Textarea: 500-char message (profanity filtered)

3. **Step 2 – Delivery Tier**  
   - Radio buttons: $5 / $20 / $50  
   - Queue priority and ETA info displayed  
   - Explanation of FIFO logic and benefits of higher tier

4. **Step 3 – Payment**  
   - Email input (required for support + receipts)  
   - Stripe Elements embedded card input  
   - Button: “Pay & Send YellShot!”

5. **Step 4 – Confirmation**  
   - Visual feedback inline  
   - No page redirects  
   - Confirmation: “Your YellShot is locked and loaded.”

---
📞 YellShot Call Types (User’s First Choice)

Breakup or Goodbye
Whether you're heartbroken, ice-cold, or just done — end it your way.

Confession or Apology
Guilt? Regret? Something unsaid? Time to get it off your chest.

Roast or Savage Burn
They deserve it — and you’ve got backup. Let’s go scorched earth.

Petty Grievance
Not a big deal… but big enough to call in reinforcements.

Flirty Confession or Crush Reveal
Shoot your shot — anonymously, seductively, or straight-up weird.

Birthday or Celebration
Loud. Awkward. Extra. Wish them a happy one they’ll never forget.

Weird or Surreal
Make them question reality. No context required.

Gratitude or Encouragement
Sincere? Mysterious? Uplifting? Be the voice that brightens their day.

Revenge Message
For the ex-friend, the fake cousin, the cheater. Sweet, poetic justice.

Custom Freestyle
Write anything. Choose any persona. Unleash your creativity.

---

## 📦 Call Type to Agency Map

| **Call Type**                    | **Agencies / Organizations**                                                                                                                                                          |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **1. Breakup or Goodbye**        | The Bureau of Second Chances, The Division of Professional Farewells, The Naval Authority of Necessary Pain, The Department of Cold Truths, The Institute of Unfinished Business     |
| **2. Confession or Apology**     | The Institute of Unfinished Business, The Bureau of Second Chances, The Institute of Flaming Truth, The Hotline of Lost Frequencies, The Office of Emotional Compliance               |
| **3. Roast or Savage Burn**      | The Department of Disrespect, The Naval Authority of Necessary Pain, The Church of Consequences, The Archive of Grudges, The Office of Uplift & Sarcasm                             |
| **4. Petty Grievance**           | The Department of Disrespect, The Archive of Grudges, The Office of Emotional Compliance, The Church of Consequences, The Department of Cold Truths                                 |
| **5. Flirty Confession / Crush** | The Office of Forbidden Longing, The Bureau of Dangerous Chemistry, The Commission of Carnal Misconduct, The Department of Unspoken Desires, The Office of Midnight Submissions     |
| **6. Birthday / Celebration**    | The Ministry of Maximum Celebration, The Department of Birthday Misconduct, The Office of Uplift & Sarcasm, The Ministry of Fond Recollections, The Department of Wishes & Cheer     |
| **7. Weird or Surreal**          | The Hotline of Lost Frequencies, The Signal Cathedral, The Bureau of Anomalous Calls, The Office of Unexplained Phenomena, The Ministry of Liminal Communication                    |
| **8. Gratitude / Encouragement** | The Ministry of Maximum Celebration, The Department of Unwavering Support, The Office of Genuine Appreciation, The Ministry of Future Potential, The Bureau of Shared Joy           |
| **9. Revenge Message**           | The Archive of Grudges, The Church of Consequences, The Department of Disrespect, The Naval Authority of Necessary Pain, The Department of Cold Truths                              |
| **10. Custom Freestyle**         | User picks persona; agency intro plays accordingly                                                                                                                                    |


---

## 🎭 Call Type to Persona Map

| **Call Type**                    | **Personas**                                                                                                                                              |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **1. Breakup or Goodbye**        | Miss Closure, Agent Farewell, Doctor Detachment, Dean of Disconnect, Professor Ghost                                                                     |
| **2. Confession or Apology**     | The Absolver Agent, Reverend Remorse, The Guilt Tripper, Minister of Making Amends, Captain Sorry Not Sorry                                              |
| **3. Roast or Savage Burn**      | Captain Cutdeep, Agent Verbal Assassin, The Baron of Brutality, Professor Roast, Sir Spite                                                               |
| **4. Petty Grievance**           | Reverend Petty, Doctor Gripe, Captain Tattle, The Baron of Bother, The Duchess of Dumb Shit                                                              |
| **5. Flirty Confession / Crush** | Dr. Confession, Agent Heartthrob, Mistress Voltage, Commander Thirst, Whisper Unit 69                                                                    |
| **6. Birthday / Celebration**    | The Maestro of Cheer, Captain Confetti, Agent Party Animal, Lord of Balloons, The Birthday Bureaucrat                                                   |
| **7. Weird or Surreal**          | Professor Reality Bender, Doctor Paradox, The Curator of Oddities, Agent Uncanny, Captain Cognitive Dissonance                                          |
| **8. Gratitude / Encouragement** | The Minister of Motivation, The Ambassador of Appreciation, High Priest of Hype, Sergeant Sunshine, The Encourager General                              |
| **9. Revenge Message**           | The Vice Principal of Pain, Commander Karma, Doctor Vengeance, Agent Payback, The Director of Consequence                                               |
| **10. Your Name or Custom Name** | Insert Name                                                                                                                                              |


---

## FAQ
To be added to the bottom of the public page.

What is the success rate?
- 99% of our messages are received as follows:
- 50% pick up on first call attempt
- 30% click the callback link
- 19% receive a text message of your message, since they failed to pickup or callback
- Less than 1% fail due to some obscure reason unrelated to YellShot.com

What if the call does not go through?
If the recipient does not answer, hangs up, or the wrong person answers the call then:
- A text message will be sent encouraging them to initiate a call back when they are ready to receive the message.  This link will remain active for 10 days before it will expire.
- A final call attempt will be made 1 hr after the original attempt.
- A text message of your message will be sent, since they failed to pickup or callback

Are failures refunded?
We are unable to offer refunds for several reasons, including the fact that bad actors would then exploit our service to harass numbers they know will not pick up (and therefore get an auto-refund).
Fortunately our service has a high success rate, so you're unlikely to ever want a refund anyhow.

---

## ⛔ No Redirects

All confirmations, errors, and visual feedback are inline.  
This maintains the emotional rhythm and narrative flow of the experience.

---
