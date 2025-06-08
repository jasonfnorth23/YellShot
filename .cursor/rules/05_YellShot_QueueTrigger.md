---
description: 
globs: 
alwaysApply: false
---
# 📥 YellShot PRD – 01: Queue Trigger (Post-Payment to Queued)

## 🎯 Purpose
Handles the transition from Stripe-confirmed payment to a queued call task.

---

## 🔁 Flow Overview

1. User submits message form → `pending_message` saved
2. Stripe `PaymentIntent` created with metadata
3. Stripe webhook confirms payment
4. Backend sets `status = payment_confirmed`
5. Message is enqueued with `expires_at` calculated from delivery tier

---
## Orchestration
- Add orchestration between LLM, Cartesia, and call queue

---

## 🔁 Queue Status Lifecycle

- `pending_payment`: message form saved before Stripe payment
- `payment_confirmed`: Stripe webhook confirms successful payment
- `queued_for_delivery`: added to call queue based on tier
- `in_progress`: call has been initiated by Twilio, awaiting outcome
- `delivered`: call completed, message delivered via Twilio
- `response_recorded`: recipient’s reaction recorded
- `undelivered`: all retry attempts failed within SLA window

---

## 🗃️ Example Queue Record

```json
{
  "id": "msg_abc123",
  "email": "user@example.com",
  "phone_number": "+15551234567",
  "call_type": "Confession",
  "persona": "Dr. Confession",
  "message": "I never told you how I really felt...",
  "tier": "20",
  "status": "payment_confirmed",
  "stripe_id": "pi_abc123",
  "twilio_sid": null,
  "audio_url": null,
  "created_at": "2025-06-04T10:00:00Z",
  "updated_at": "2025-06-04T10:05:00Z",
  "expires_at": "2025-06-04T11:00:00Z"
}
```

---

## ⏳ Expiration Calculation

| Tier  | Max SLA |
|-------|---------|
| $5    | 8 hours |
| $20   | 1 hour  |
| $50   | 15 min  |

- `expires_at = payment_confirmed + SLA`

---

## 🧠 Notes

- If Stripe webhook arrives but no `pending_message`, log for manual review
- If already queued, ignore duplicate webhook
- This system must integrate tightly with:
  - Stripe webhooks
  - Twilio programmable voice
  - Delivery tier prioritization engine
- All timing logic enforced server-side to prevent manipulation
- Queue processor should scan and dequeue based on:
  - Tier priority
  - `expires_at` cutoff
  - Current system capacity
