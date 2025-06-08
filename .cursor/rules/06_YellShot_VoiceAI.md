---
description: 
globs: 
alwaysApply: false
---
# 🧠 YellShot PRD – 03: Voice AI Persona Engine

## 🎯 Purpose
Defines how the Voice AI system delivers messages using fictional personas, pre-configured voice models, and dynamic follow-up prompts. Ensures every call feels immersive, theatrical, and consistent with YellShot’s surreal, adult tone.

---
## Tech Stack
- Cartesia API Key: sk_car_YigdRus4zPGZ1E7XSsbedb

---

## 🧠 Conversation Logic (LLM)

- LLM deployment details (Ollama / Mixtral / etc.)
- Persona prompt template structure
- Endpoint spec: /generate-response
- Fallback logic / retry patterns
- Voice model ↔ prompt integration

---

## 🔊 Voice Synthesis – Cartesia API
- API request format
- Voice ID config per persona
- Expected output (MP3 URL)
- Storage + retry logic

---

## 🎭 Call Type to Persona Map (Simplified 1M / 1F)

| **Call Type**               | **Male Persona**               | **Female Persona**                |
|----------------------------|--------------------------------|-----------------------------------|
| Breakup or Goodbye         | Agent Farewell                 | Lady Letdown                      |
| Confession or Apology      | Reverend Remorse               | Sister Sorry                      |
| Roast or Savage Burn       | Captain Cutdeep                | The Empress of Evisceration       |
| Petty Grievance            | Doctor Gripe                   | Mother Malcontent                 |
| Birthday / Celebration     | The Maestro of Cheer           | DJ Glitterbomb                    |
| Weird or Surreal           | Professor Reality Bender       | The Oracle of Broken TVs          |
| Gratitude / Encouragement  | The Minister of Motivation     | Lady Uplift                       |
| Revenge Message            | Commander Karma                | Madame Payback                    |
                                                                                                                                 |
---

## 🎙️ Allowed Tone Labels

- `savage`
- `regretful`
- `clinical`
- `sarcastic`
- `glitchy`
- `cheerful`
- `soothing`
- `deranged`
- `mysterious`
- `robotic`

*Used in stir-the-pot prompt selection, voice generation metadata, and persona search.*

---

## 🧬 Persona Configuration

Each persona is defined by:

- `persona_id`: Unique string ID
- `display_name`: What is spoken and shown
- `voice_id`: ElevenLabs UUID
- `gender`: "male", "female", or "custom"
- `tone`: Describes delivery style (e.g., sarcastic, sincere, deranged)
- `intro_script`: “This is [Persona], calling from the [Agency]. I have a confidential message for [Name]...”

Voice gender must match persona gender unless explicitly marked as neutral or glitch.

---

## 🎭 Persona Prompt Rules

- Each persona maps to:
  - Voice model (e.g., ElevenLabs ID)
  - Intro script
  - Personality tone
  - Optional follow-up prompts

---

# 🗣️ Voice-to-Gender Mapping (New Balanced Additions)

| **Voice ID**              | **Display Name**                   | **Gender** |
|---------------------------|------------------------------------|------------|
| elv_046_lady_letdown      | Lady Letdown                       | Female     |
| elv_047_moving_on         | The Matriarch of Moving On         | Female     |
| elv_048_sister_sorry      | Sister Sorry                       | Female     |
| elv_049_countess_contrit  | The Countess of Contrition         | Female     |
| elv_050_empress_evis      | The Empress of Evisceration        | Female     |
| elv_051_lady_scorn        | Lady Scorn                         | Female     |
| elv_052_mother_malcontent | Mother Malcontent                  | Female     |
| elv_053_auntie_whine      | Auntie Whine                       | Female     |
| elv_054_baroness_balloons | Baroness of Balloons               | Female     |
| elv_055_dj_glitterbomb    | DJ Glitterbomb                     | Female     |
| elv_056_oracle_broken     | The Oracle of Broken TVs           | Female     |
| elv_057_miss_dissonance   | Miss Dissonance                    | Female     |
| elv_058_lady_uplift       | Lady Uplift                        | Female     |
| elv_059_hype_nun          | The Hype Nun                       | Female     |
| elv_060_madame_payback    | Madame Payback                     | Female     |
| elv_061_widow_wreckage    | The Widow of Wreckage              | Female     |

---

## 🗣️ Voice-to-Gender Mapping (New Balanced Additions – Male)

| **Voice ID**              | **Display Name**                   | **Gender** |
|---------------------------|------------------------------------|------------|
| elv_062_farewell_agent    | Agent Farewell                     | Male       |
| elv_063_detachment_doc    | Doctor Detachment                  | Male       |
| elv_064_absolver_agent    | The Absolver Agent                 | Male       |
| elv_065_reverend_remorse  | Reverend Remorse                   | Male       |
| elv_066_cutdeep_captain   | Captain Cutdeep                    | Male       |
| elv_067_verbal_assassin   | Agent Verbal Assassin              | Male       |
| elv_068_reverend_petty    | Reverend Petty                     | Male       |
| elv_069_doctor_gripe      | Doctor Gripe                       | Male       |
| elv_070_cheer_maestro     | The Maestro of Cheer               | Male       |
| elv_071_confetti_captain  | Captain Confetti                   | Male       |
| elv_072_bender_prof       | Professor Reality Bender           | Male       |
| elv_073_paradox_doc       | Doctor Paradox                     | Male       |
| elv_074_minister_motivate | The Minister of Motivation         | Male       |
| elv_075_ambassador_apprec | The Ambassador of Appreciation     | Male       |
| elv_076_principal_pain    | The Vice Principal of Pain         | Male       |
| elv_077_commander_karma   | Commander Karma                    | Male       |

### 📊 Database Logic (Pseudocode)

```sql
SELECT COUNT(*) FROM queue_history
WHERE recipient_phone = '<number>'
```

- If result = 0 → allow free promo
- Else → deny promo, proceed to payment step

---

### 🧬 SMS Reply Link Handling

- If **promo allowed**:
  ```
  Want to reply anonymously?  
  Tap here to respond FREE:  
  https://yellshot.com/reply/<token>?promo=1
  ```
- If **promo denied**:
  ```
  Want to reply anonymously?  
  Tap here to respond:  
  https://yellshot.com/reply/<token>
  ```

> Frontend checks for `promo=1` query param to unlock free usage

---

### 🧾 Metadata Fields (Database)

```json
{
  "recipient_phone": "+15555551234",
  "has_received_before": true,
  "promo_eligible": false,
  "reply_token": "abc123",
  "promo_used": false
}
```

---

### 🧠 Anti-Gaming Note

- Token is single-use and locked to `recipient_phone`
- Free promo flag invalidated upon:
  - Successful reply purchase
  - Or expiration window (e.g. 48 hours)

---

## 🔊 Voice Synthesis Engine

- Uses Cartesia AI API for text-to-speech.
- Each prompt is composed using:

```text
[intro_script] + " " + [user_message] + " " + [optional_follow_up_question]
```

- Example:

This is Miss Closure, calling from the Bureau of Second Chances. I have a confidential message for Jamie.  It reads:
"I still think about you at night. It’s dumb, I know."

"What would you do if I said it in person?"

- Configuration includes:
- `stability`
- `similarity_boost`
- `speed`
- `style` (if supported)

---

## 📦 Persona Registration Schema

```json
{
  "persona_id": "lady_letdown",
  "display_name": "Lady Letdown",
  "voice_id": "elv_046_lady_letdown",
  "tone": "regretful",
  "call_type": "Breakup or Goodbye",
  "tags": ["female", "soft", "closure", "emotional"]
}
```

---

## 🔊 Cartesia AI API Configuration

| **Setting**         | **Default** | **Notes**                                  |
|---------------------|-------------|--------------------------------------------|
| `stability`         | 0.5         | Adjust for more/less consistency           |
| `similarity_boost`  | 0.8         | Higher = more predictable                  |
| `style`             | varies      | Optional. For expressive voices only       |
| `voice_id`          | from persona | Must match gender and intended tone       |

---

## 🧬 Voice File Output

- `ai_message.mp3`: AI-generated message
- `reaction.mp3`: User’s recorded reply
- `final_call.mp3`: Merged delivery + reply

**Stored at:**  
`/audio/{call_id}/{file}.mp3`

**Example:**  
`https://cdn.yellshot.com/audio/92f883ac/final_call.mp3`

---

## 🧾 Persona Tag Index

| **Tag**         | **Description**                                             |
|-----------------|-------------------------------------------------------------|
| `female`        | Identifies a female-presenting persona                      |
| `male`          | Identifies a male-presenting persona                        |
| `neutral`       | Ambiguous or non-gendered voice (used in fallback cases)    |
| `glitch`        | Distorted or intentionally unstable voice models            |
| `funny`         | Designed for humor, satire, or irreverence                  |
| `NSFW-ok`       | Can be used in explicit or adult-themed messages            |
| `closure`       | Calm, surgical tone for breakup or resolution               |
| `vengeful`      | Cold or cutting tone for revenge/retribution                |
| `quirky`        | Bizarre, absurd, or surreal personalities                   |
| `encouraging`   | Uplifting and affirming tone                                |

---

## 🧭 Fallback Narrator Voices

| **Fallback ID**      | **Display Name**        | **Gender** | **Tone**     | **Use Case**                                |
|----------------------|-------------------------|------------|--------------|---------------------------------------------|
| narrator_soft        | Neutral Narrator        | Neutral    | Soothing     | Used when persona voice is missing          |
| narrator_glitch      | System Interference Bot | Neutral    | Glitchy      | Used for corrupted or surreal delivery      |
| narrator_legal       | Compliance Voice        | Neutral    | Clinical     | Used for legal/service-of-notice style      |

Fallbacks are used when persona voice is unavailable or for specific edge-case scripts.

---

## 📦 Call Type Metadata

| **Call Type**               | **Description**                                                       | **Default Tone** |
|----------------------------|------------------------------------------------------------------------|------------------|
| Breakup or Goodbye         | Ending romantic or personal relationships with finality               | regretful        |
| Confession or Apology      | Delivering guilt, remorse, or truth                                    | sincere          |
| Roast or Savage Burn       | Harsh, funny, or humiliating messages for entertainment               | savage           |
| Petty Grievance            | Small complaints with exaggerated emotional charge                    | sarcastic        |
| Birthday / Celebration     | Joyful, ridiculous, or surreal birthday greetings                     | cheerful         |
| Weird or Surreal           | Bizarre, dreamlike, or glitchy transmissions                          | glitchy          |
| Gratitude / Encouragement  | Uplifting, affirming, motivational                                    | soothing         |
| Revenge Message            | Cold, cruel, or justice-themed messages                               | deranged         |

---

## 🧪 Debug Mode Prompt Output

Enable debug mode to log and inspect composed prompts before generation:

```json
{
  "persona": "Professor Roast",
  "voice_id": "elv_014_professor_roast",
  "tone": "savage",
  "final_prompt": "This is Professor Roast from The School of Hard Burns... [message] ... [follow-up]"
}

---

## 🔒 Consent Statement (Standard)

"This call may be recorded for quality and verification purposes.  
By continuing to listen, you consent to being recorded."

*Required before any message content begins.*

---

## 🎭 Flavor Add-ons (Optional, After Consent)

| **Call Type**               | **Flavor Add-On**                                                   |
|----------------------------|----------------------------------------------------------------------|
| Breakup or Goodbye         | “Let’s make this clean. Or messy. That’s up to you.”                |
| Confession or Apology      | “Time to unload what’s been crawling around your conscience.”       |
| Roast or Savage Burn       | “You might feel this one in your ego.”                              |
| Petty Grievance            | “This one’s petty. But also… kind of true.”                         |
| Birthday / Celebration     | “Let’s blow out more than just candles.”                            |
| Weird or Surreal           | “This may not make sense — but neither does your dating history.”   |
| Gratitude / Encouragement  | “No sarcasm here — just a rare hit of genuine appreciation.”        |
| Revenge Message            | “This might sting. Good.”                                           |

*These lines are optional, delivered after the standard legal consent to re-establish tone.*

---

## 📣 Persona Intro Script Variants

| **Tone**      | **Intro Snippet**                                                                 |
|---------------|------------------------------------------------------------------------------------|
| Regretful     | “This is {persona}, calling from the {agency}. I’ve been asked to deliver something heavy.” |
| Savage        | “Brace yourself. {persona} from the {agency} here with a message they didn’t dare say out loud.” |
| Cheerful      | “Hey hey! It’s {persona}, ringing from the {agency} of celebrations. Got a surprise!”         |
| Glitchy       | “—signal acquired—{persona} speaking… from somewhere not quite real…”                        |
| Clinical      | “This is {persona}, delivering a structured message on behalf of the {agency}.”              |

---

## 🧠 Prompt Composition Logic

Final message =  
`[intro_script] + [legal_consent] + [flavor_addon] + [user_message] + [stir_the_pot] + [escalation] + [cta]`

- Prompts are filtered by persona tone
- Optional debug mode logs all inputs and final strings
- Prompts are truncated if total length exceeds API limits

---

## 🧪 Voice QA & Testing Checklist

- ✅ Does the tone match the persona’s intent?
- ✅ Is the consent line clear, upfront, and neutral?
- ✅ Are pauses/breaths/natural flow acceptable?
- ✅ Is there audio clipping or artifacting?
- ✅ Did the AI voice say all dynamic names correctly?

*Record at least 1 test call per persona per call type before release.*

---

## 📊 Persona Analytics Fields

```json
{
  "persona_id": "mistress_voltage",
  "calls_sent": 344,
  "avg_reaction_time": 9.2,
  "click_rate_reply_link": 41.7,
  "last_used": "2025-06-05"
}

---

## 📤 Reply Metadata Example

```json
{
  "reply_text": "Tell them to grow up.",
  "reply_tone": "dismissive",
  "reply_received_at": "2025-06-05T16:44:21Z",
  "link_clicked": true
}

---

#### 2. **🧠 Stir-the-Pot Prompt Examples by Tone**
Just 1–2 per tone as reference for writers/QA.

```mdc
## 🧠 Stir-the-Pot Prompt Samples

| **Tone**   | **Sample Prompt**                                      |
|------------|--------------------------------------------------------|
| Savage     | “Did that truth hit harder than your last relationship?” |
| Regretful  | “Would you take it back if you could?”                 |
| Cheerful   | “Isn’t life too short to hold grudges?”               |
| Glitchy    | “::data inconsistency detected:: still feel that way?” |

---

## 📘 Persona Design Notes

- Each persona should have:
  - A distinct vocal tone and lexicon
  - A fictional agency name that reinforces theme
  - Clear alignment with 1–2 call types
  - A “signature” intro line or catchphrase (optional)

Use tags to control appearance frequency, edginess, or NSFW boundaries.

---

## 🛑 Moderation & Blocklist Filters

Before synthesis, input is filtered against a dynamic keyword list:

```json
{
  "blocklist": [
    "kill yourself",
    "slur:*",
    "racial hate",
    "private phone number",
    "home address",
    "death threat"
  ],
  "moderation_actions": {
    "replace": "[censored]",
    "flag": true,
    "log": true
  }
}
```

*Optional user alert: “Your message has been lightly edited for compliance.”*

---

## 🎯 Auto-Tone Validation Logic

Before generation, AI checks for **tone mismatch** between message and persona tone:

```json
{
  "persona_tone": "cheerful",
  "user_message": "I hope your cat dies and your house burns down.",
  "tone_alignment_score": 0.08,
  "action": "warn_user"
}
```

If score < `0.2`, alert user or suggest alternate persona:
> “This message may not align with your selected tone. Try a different persona?”

---

## 📁 Audio Output

- `ai_message.mp3`: Generated voice delivery
- `reaction.mp3`: User's recorded reply (if any)
- `final_call.mp3`: Merged audio file (delivery + reply)

- Metadata stored:

```json
{
"call_type": "Flirty Confession / Crush",
"persona": "Commander Thirst",
"voice_id": "elv_024_commander_thirst",
"gender": "male",
"timestamp": "2025-06-05T15:20:45Z"
}
```

---

## 🧯 Error Handling

| **Scenario**                  | **Behavior**                                                                 |
|------------------------------|------------------------------------------------------------------------------|
| Missing or invalid `voice_id`| Use fallback voice for persona gender; log a warning                         |
| Gender mismatch              | Block persona selection; display UI validation error                         |
| ElevenLabs API timeout       | Retry up to 2x; fallback to narrator voice if needed                         |
| Prompt exceeds token limit   | Truncate message and alert user                                              |
| Invalid characters in input  | Sanitize before synthesis                                                    |
| Voice synthesis fails        | Log to `voice_error.log`, retry automatically, escalate if still failing     |

---