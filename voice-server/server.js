// server.js – FINAL WORKING VERSION for Cartesia
require('dotenv').config();
const express = require('express');
const fs = require('fs');
const path = require('path');
const axios = require('axios');
const voiceMap = require('./voiceMap');
const ConversationManager = require('./conversationManager');

const app = express();
const PORT = process.env.PORT || 3000;
const CALLS_DIR = path.join(__dirname, 'calls');
const LOG_FILE = path.join(__dirname, 'cartesia_error.log');

if (!fs.existsSync(CALLS_DIR)) {
  fs.mkdirSync(CALLS_DIR, { recursive: true });
}

console.log('✅ Loaded Cartesia API Key:', process.env.CARTESIA_API_KEY ? 'YES' : 'NO');

const conversationManager = new ConversationManager(process.env.CARTESIA_API_KEY, CALLS_DIR);

app.use(express.json());
app.use('/calls', express.static(CALLS_DIR));

app.post('/generate-voice', async (req, res) => {
  const { response_text, voice_id } = req.body;

  if (!response_text || !voice_id || !voiceMap[voice_id]) {
    return res.status(400).json({ error: 'Invalid input or unknown voice_id' });
  }

  const filename = `${Date.now()}_${voice_id}.wav`;
  const filePath = path.join(CALLS_DIR, filename);
  const outputUrl = `http://localhost:${PORT}/calls/${filename}`;

  try {
    const response = await axios.post(
      'https://api.cartesia.ai/tts/bytes',
      {
        model_id: 'sonic-2',
        transcript: response_text,
        voice: {
          mode: 'id',
          id: voiceMap[voice_id]
        },
        output_format: {
          container: 'wav',
          encoding: 'pcm_f32le',
          sample_rate: 44100
        },
        language: 'en'
      },
      {
        headers: {
          'X-API-Key': process.env.CARTESIA_API_KEY,
          'Cartesia-Version': '2024-06-10',
          'Content-Type': 'application/json'
        },
        responseType: 'stream'
      }
    );

    const writer = fs.createWriteStream(filePath);
    response.data.pipe(writer);

    writer.on('finish', () => {
      console.log('✅ Audio file saved:', filename);
      res.json({ audio_url: outputUrl });
    });

    writer.on('error', (err) => {
      console.error('❌ File write error:', err);
      res.status(500).json({ error: 'Failed to save audio file' });
    });

  } catch (error) {
    console.error('❌ Cartesia API ERROR');
    console.error('🔴 MESSAGE:', error.message);

    if (error.response) {
      console.error('🔴 STATUS:', error.response.status);
      console.error('🔴 DATA:', error.response.data);
    } else if (error.request) {
      console.error('📡 No response received:', error.request);
    } else {
      console.error('💥 Unexpected Error:', error);
    }

    try {
      const logDump = {
        timestamp: new Date().toISOString(),
        message: error.message,
        status: error.response?.status || 'No status',
        data: error.response?.data || 'No data'
      };
      fs.writeFileSync(LOG_FILE, JSON.stringify(logDump, null, 2), 'utf-8');
    } catch (logErr) {
      console.error('❌ Failed to write to error log:', logErr);
    }

    res.status(500).json({ error: 'Cartesia TTS request failed' });
  }
});

app.post('/generate-conversation', async (req, res) => {
  const {
    personaName,
    agencyName,
    targetName,
    privateMessage,
    voiceId
  } = req.body;

  if (!personaName || !agencyName || !targetName || !privateMessage || !voiceId) {
    return res.status(400).json({ error: 'Missing required parameters' });
  }

  try {
    const callId = Date.now();
    const result = await conversationManager.generateFullConversation({
      personaName,
      agencyName,
      targetName,
      privateMessage,
      voiceId,
      callId
    });

    // Convert file paths to URLs
    const sequence = result.sequence.map(item => ({
      ...item,
      url: `http://localhost:${PORT}/calls/${item.file}`
    }));

    res.json({
      callId,
      sequence
    });
  } catch (error) {
    console.error('❌ Conversation generation error:', error);
    res.status(500).json({ error: 'Failed to generate conversation' });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Voice Synthesis Server running at http://localhost:${PORT}`);
});
