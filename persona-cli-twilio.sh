#!/bin/zsh
# Updated on 2025-06-07

echo "🎭 YellShot Persona Selector CLI"

# Step 1: Select Call Type
echo ""
echo "📞 Choose a Call Type:"
call_types=(
  "Breakup or Goodbye"
  "Confession or Apology"
  "Roast or Savage Burn"
  "Petty Grievance"
  "Flirty Confession / Crush"
  "Birthday / Celebration"
  "Weird or Surreal"
  "Gratitude / Encouragement"
  "Revenge Message"
  "Custom Name"
)

for i in {1..10}; do
  echo "$i. ${call_types[$i]}"
done

read -r "?> " call_type_choice

case $call_type_choice in
  1) personas=("Agent Farewell" "Doctor Detachment") ;;
  2) personas=("The Absolver Agent" "Reverend Remorse") ;;
  3) personas=("Captain Cutdeep" "Lady Scorn") ;;
  4) personas=("Reverend Petty" "Auntie Whine") ;;
  5) personas=("The Flirtician" "Madame Blush") ;;
  6) personas=("Captain Candlelight" "The Maestro of Cheer") ;;
  7) personas=("Sister Static" "The Oracle of Broken TVs") ;;
  8) personas=("General Uplift" "The Kindly Voice") ;;
  9) personas=("Agent Verbal Assassin" "The Empress of Evisceration") ;;
  10)
    echo -n "🎨 Enter custom persona name: "
    read -r custom_persona
    personas=("$custom_persona")
    ;;
  *) echo "❌ Invalid choice"; exit 1 ;;
esac

# Step 2: Choose Persona
echo ""
echo "🎙️  Choose a Persona:"
i=1
for p in "${personas[@]}"; do
  echo "$i) $p"
  ((i++))
done
read -r "?# " persona_choice
persona="${personas[$persona_choice]}"

if [[ -z "$persona" ]]; then
  echo "❌ Invalid persona selection"
  exit 1
fi

# Step 3: Enter Details
echo ""
read -r "?👤 Recipient Name: " recipient_name
read -r "?📞 Recipient Phone (e.g. +15551234567): " recipient_phone
read -r "?🎭 Tone (e.g., remorseful, savage, sweet): " tone
read -r "?📝 Your message: " user_message

# Step 4: Generate LLM Response
echo ""
echo "🧠 Sending message to LLM..."
response=$(curl -s -X POST http://localhost:3000/generate-response \
    -H "Content-Type: application/json" \
    -d "{
        \"persona\": \"$persona\",
        \"message\": \"$user_message\",
        \"recipient_name\": \"$recipient_name\",
        \"tone\": \"$tone\"
    }")

response_text=$(echo "$response" | jq -r '.response_text' 2>/dev/null)

echo ""
echo "✅ LLM Response:"
echo "$response_text"

# Step 5: Generate Cartesia Voice
echo ""
echo "🎤 Generating voice via Cartesia AI..."
voice_output=$(curl -s -X POST http://localhost:3000/generate-voice \
    -H "Content-Type: application/json" \
    -d "{
        \"response_text\": \"$response_text\",
        \"voice_id\": \"test_voice_id\"
    }")

audio_url=$(echo "$voice_output" | jq -r '.audio_url' 2>/dev/null)

# Save and play voice
mkdir -p ./calls
safe_persona=$(echo "$persona" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
filename="test_${safe_persona}_$(date +%Y%m%d_%H%M%S).mp3"
output_file="./calls/$filename"

echo "⬇️  Downloading MP3 to: $output_file"
curl -s -o "$output_file" "$audio_url"

echo "🔊 Playing message..."
afplay "$output_file" 2>/dev/null || echo "⚠️ Could not play file."

# Step 6: Queue via Twilio
echo ""
echo "📞 Queuing call via Twilio..."
queue_response=$(curl -s -X POST http://localhost:3000/queue-call \
    -H "Content-Type: application/json" \
    -d "{
        \"phone\": \"$recipient_phone\",
        \"audio_url\": \"$audio_url\",
        \"call_type\": \"${call_types[$call_type_choice]}\",
        \"persona\": \"$persona\"
    }")

echo ""
echo "📲 Queue response:"
echo "$queue_response"

echo ""
echo "✅ Done. Message voiced, played, and call queued."
