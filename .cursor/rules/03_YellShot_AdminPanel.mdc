---
description: 
globs: 
alwaysApply: false
---
# 🛠️ 02_YellShot_AdminPanel.mdc — Admin Interface PRD

## 🎯 Purpose
The YellShot Admin Panel is a secure, authenticated interface used by the site owner to:

- View all inbound YellShot requests
- Monitor call delivery and recording status
- Access payment info via Stripe
- Listen to/download call recordings
- View errors or failed calls

---

## 🔐 Authentication
- Admin panel is behind a login (password-protected)
- Session stored securely
- No public access to this panel or its data

---

## 📊 Admin Dashboard UI

| Column              | Description                                             |
|---------------------|---------------------------------------------------------|
| Call ID             | Unique ID tied to each message                         |
| Timestamp           | Time the message was submitted                         |
| Call Type           | e.g., Breakup, Confession, Roast                       |
| Persona             | Persona used to deliver the call                      |
| Phone Number        | Obfuscated or masked view only                        |
| Message Preview     | Truncated text of original message                    |
| Delivery Tier       | $5 / $20 / $50 with associated ETA                   |
| Status              | Pending, Queued, Success, Failed                      |
| Recording Link      | Stream + Download audio (.mp3)                        |
| Stripe Link         | View payment metadata                                 |
| Sender Email        | Captured from payment page                            |

---

## 📁 Features

- **Sortable** by any column
- **Filter** by Status (Queued, Failed, Completed, etc.)
- **Search** by Call ID, Phone Number, Email
- **Audio Player** inline with download option
- **Auto-refresh** every 60 seconds for latest call statuses
- Visual indicators for call errors (e.g. failed Twilio webhook)
- Optional: Export CSV of calls (admin-only tool)

---

## ⛓️ Backend Queue Flow (Recap)

1. User fills out public form → `pending_message` record saved
2. Stripe payment initiated via Elements
3. Stripe webhook confirms payment → status updated to “queued”
4. Call executed via Twilio:
   - Recording and recipient response stored
   - Admin panel displays result

---

## 🧠 Developer Notes

- Store call records in database with indexed `status` and `created_at`
- Save audio files with secure URLs in backend storage (S3 or equivalent)
- Admin page loads paginated results (50 per page)
- All actions are **read-only** for now (no delete/edit in MVP)

---