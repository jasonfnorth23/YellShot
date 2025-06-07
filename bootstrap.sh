#!/bin/bash
echo ""
echo "🎛️  Welcome back, Commander. YellShot is armed and unstable."
afplay ./sounds/yellshot_boot.wav &

# Load env
if [ -f .env ]; then
  echo "📦 Loading .env file..."
  export $(cat .env | grep -v '#' | xargs)
else
  echo "⚠️  No .env file found. Create one based on .env.example."
  exit 1
fi

# Start local LLM if needed
if pgrep -f "ollama" > /dev/null; then
  echo "🧠 LLM (Ollama) already running"
else
  echo "🧠 Starting LLM (Mixtral via Ollama)..."
  ollama run mixtral &
  sleep 3
fi

# Confirm API test
echo "📡 Testing /generate-response..."
curl -s -X POST http://localhost:3000/generate-response \
  -H "Content-Type: application/json" \
  -d '{
    "persona": "Dr. Confession",
    "message": "I never should have ghosted you.",
    "recipient_name": "Alex",
    "tone": "remorseful"
  }' | jq

# Confirm Cartesia key is loaded
if [ -z "$CARTESIA_API_KEY" ]; then
  echo "❌ CARTESIA_API_KEY not set in .env"
else
  echo "🎤 Cartesia API key verified ✓"
fi

# Optional: Launch dev server
echo "🌐 Launching dev API server..."
npm run dev

echo ""
echo "✅ Boot complete. Time to make someone cry with AI. 💔🤖"
