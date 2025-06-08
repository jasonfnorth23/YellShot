const axios = require('axios');
const fs = require('fs');
const path = require('path');
const voiceMap = require('./voiceMap');

class ConversationManager {
  constructor(apiKey, callsDir) {
    this.apiKey = apiKey;
    this.callsDir = callsDir;
    this.ensureCallsDirectory();
  }

  ensureCallsDirectory() {
    if (!fs.existsSync(this.callsDir)) {
      fs.mkdirSync(this.callsDir, { recursive: true });
    }
  }

  async generateVoice(text, voiceId, filename) {
    try {
      const response = await axios.post(
        'https://api.cartesia.ai/tts/bytes',
        {
          model_id: 'sonic-2',
          transcript: text,
          voice: {
            mode: 'id',
            id: voiceMap[voiceId]
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
            'X-API-Key': this.apiKey,
            'Cartesia-Version': '2024-06-10',
            'Content-Type': 'application/json'
          },
          responseType: 'stream'
        }
      );

      const filePath = path.join(this.callsDir, filename);
      const writer = fs.createWriteStream(filePath);
      response.data.pipe(writer);

      return new Promise((resolve, reject) => {
        writer.on('finish', () => resolve(filePath));
        writer.on('error', reject);
      });
    } catch (error) {
      console.error('Voice generation error:', error.message);
      throw error;
    }
  }

  async generateFullConversation(params) {
    const {
      personaName,
      agencyName,
      targetName,
      privateMessage,
      voiceId,
      callId
    } = params;

    const files = [];

    // 1. Intro & Identity Check
    const introText = `Hello. This is ${personaName}, calling from the ${agencyName}. I have a private message for ${targetName}. Is this ${targetName}?`;
    files.push(await this.generateVoice(introText, voiceId, `${callId}_intro.wav`));

    // 2. Consent Message
    const consentText = "Thanks for confirming. This call may be recorded — by continuing, you consent. Ready for the message?";
    files.push(await this.generateVoice(consentText, voiceId, `${callId}_consent.wav`));

    // 3. Message Delivery
    const messageIntro = "Alright… here it is, exactly as I received it.";
    files.push(await this.generateVoice(messageIntro, voiceId, `${callId}_message_intro.wav`));
    files.push(await this.generateVoice(privateMessage, voiceId, `${callId}_message.wav`));

    // 4. Reaction Prompt
    const reactionPrompt = "That concludes the message. Care to respond?";
    files.push(await this.generateVoice(reactionPrompt, voiceId, `${callId}_reaction_prompt.wav`));

    // 5. Stir the Pot (Example - this should be dynamically generated based on context)
    const stirPotText = "Be honest — did you cheat?";
    files.push(await this.generateVoice(stirPotText, voiceId, `${callId}_stir_pot.wav`));

    // 6. Closing
    const closingText = `This message was delivered by ${personaName} via YellShot.com — Let AI do the talking. That's YELL SHOT dot com.`;
    files.push(await this.generateVoice(closingText, voiceId, `${callId}_closing.wav`));

    return {
      files,
      sequence: [
        { type: 'intro', file: `${callId}_intro.wav` },
        { type: 'consent', file: `${callId}_consent.wav` },
        { type: 'message_intro', file: `${callId}_message_intro.wav` },
        { type: 'message', file: `${callId}_message.wav` },
        { type: 'reaction_prompt', file: `${callId}_reaction_prompt.wav` },
        { type: 'stir_pot', file: `${callId}_stir_pot.wav` },
        { type: 'closing', file: `${callId}_closing.wav` }
      ]
    };
  }
}

module.exports = ConversationManager; 