---
description: 
globs: 
alwaysApply: false
---
# 💳 YellShot PRD – 05: Payment Trigger & Queue Enqueue

## 🎯 Purpose
Covers the Stripe payment flow from form submission to queue entry.

---

## 💸 Stripe + Message Flow

1. **User Submits Message Form**
   - Saves `pending_message` to DB
   - Contains call type, persona, message, delivery tier, email, phone number

2. **Stripe PaymentIntent Created**
   - Includes metadata:
     - `call_type`
     - `persona`
     - `message_id`
     - `tier`
     - `email`
     - `phone_number`

3. **Stripe Webhook Fires**
   - On success:
     - Update message status to `payment_confirmed`
     - Enqueue message with `expires_at` set by delivery tier

---
## Post-Payment Logic
- Add post-payment logic

---

## 🔐 Webhook Security

- Validate incoming webhook with Stripe secret key
- Reject if missing required metadata
- Idempotency enforced via `message_id` lock

---

## 🛂 Stripe Webhook Logic

- Endpoint: `/api/stripe/webhook`
- Signature verification required
- Metadata required:
  - `message_id`
  - `call_type`
  - `persona`
  - `tier`
  - `email`
  - `phone_number`

---

## ⏳ Expiration Calculation

| Tier | Time Window |
|------|-------------|
| $5   | 8 hours     |
| $20  | 1 hour      |
| $50  | 15 minutes  |

`expires_at = payment_confirmed + SLA`

---

## ⚠️ Edge Case Handling

- **Tab Closed After Payment**:
  - `pending_message` already exists
  - Stripe webhook will continue flow even if UI closed

- **Duplicate Payments**:
  - Prevent by locking `message_id` per Stripe session

---

## 🧠 Notes

- If webhook fails or is delayed, message stays in `pending_payment`
- If webhook received but no `pending_message`, log and alert for manual review
- Edge case: tab closed after Stripe payment = handled via webhook alone