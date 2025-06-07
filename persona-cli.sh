#!/bin/bash

echo "🎭 YellShot Persona Selector CLI"

# Step 1: Select Call Type
echo ""
echo "📞 Choose a Call Type:"
echo "1. Breakup"
echo "2. Confession"
echo "3. Roast"
echo "4. Petty Grievance"
echo "5. Birthday"
read -p "> " call_type_choice

declare -A personas
personas[1]="Agent Farewell,Doctor Detachment"
personas[2]="Sister Sorry,The Countess of Contrition"
personas[3]="Captain Cutdeep,Lady Scorn"
personas[4]="Reverend Petty,Auntie Whine"
personas[5]="Captain Candlelight,The Maestro of Cheer"

IFS=',' read -ra options <<< "${personas[$call_type_choice]}"

# Step 2: Choose Persona
echo ""
echo "🎙️  Choose a Persona:"
select persona in "${options[@]}"; do
    break
done

# Step 3: Enter Details
echo ""
read -p "👤 Recipient Name: " recipient_name
read -p "🎭 Tone (e.g., remorseful, savage, sweet): " tone
read -p "📝 Your message: " user_message

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
