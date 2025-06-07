#!/bin/zsh

echo "🎭 YellShot Persona Selector CLI"

# Step 1: Select Call Type
echo ""
echo "📞 Choose a Call Type:"
echo "1. Breakup"
echo "2. Confession"
echo "3. Roast"
echo "4. Petty Grievance"
echo "5. Birthday"
echo -n "> "
read call_type_choice

if [[ $call_type_choice == 1 ]]; then
  options=("Agent Farewell" "Doctor Detachment")
elif [[ $call_type_choice == 2 ]]; then
  options=("Sister Sorry" "The Countess of Contrition")
elif [[ $call_type_choice == 3 ]]; then
  options=("Captain Cutdeep" "Lady Scorn")
elif [[ $call_type_choice == 4 ]]; then
  options=("Reverend Petty" "Auntie Whine")
elif [[ $call_type_choice == 5 ]]; then
  options=("Captain Candlelight" "The Maestro of Cheer")
else
  echo "❌ Invalid choice"
  exit 1
fi

# Step 2: Choose Persona
echo ""
echo "🎙️  Choose a Persona:"
select persona in "${options[@]}"; do
  if [[ -n "$persona" ]]; then
    break
  fi
done

# Step 3: Enter Details
echo -n "👤 Recipient Name: "
read recipient_name

echo -n "🎭 Tone (e.g., remorseful, savage, sweet): "
read tone

echo -n "📝 Your message: "
read user_message

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
  }" | jq -r '.response_text')

echo ""
echo "✅ LLM Response:"
echo "$response"

# Step 5: Generate Cartesia Voice
echo ""
echo "🎤 Generating voice via Cartesia AI..."
voice_output=$(curl -s -X POST http://localhost:3000/generate-voice \
  -H "Content-Type: application/json" \
  -d "{
    \"response_text\": \"$response\",
    \"voice_id\": \"test_voice_id\"
  }" | jq -r '.audio_url')

# Save and play voice
mkdir -p ./calls
filename="test_$(echo $persona | tr ' ' '_' | tr '[:upper:]' '[:lower:]')_$(date +%Y%m%d_%H%M%S).mp3"
output_file="./calls/$filename"

echo "⬇️  Downloading MP3 to: $output_file"
curl -s -o "$output_file" "$voice_output"

echo "🔊 Playing message..."
afplay "$output_file"

echo ""
echo "✅ Done. Message rendered, voiced, and played."
