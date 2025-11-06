# TocoAce – Interview Coach AI

<div align="center">
  <h3>🎯 Your AI-Powered Interview Assistant for macOS</h3>
  <p>Real-time transcription + AI-generated answers to ace your interviews</p>
</div>

---

## 🌟 Features

- **Real-Time Speech Recognition** - Live transcription using Apple's Speech Recognition Framework
- **AI-Powered Answers** - Get intelligent responses powered by Claude 3.5 Sonnet, GPT-4o, or GPT-4 Turbo
- **Floating Always-On-Top Window** - Stay visible during video calls
- **Multi-Language Support** - English, Russian, Kazakh, Polish, Swedish
- **Customizable Answer Length** - Short (30-50 words), Medium (80-120 words), Long (150-200 words)
- **Context-Aware** - Upload your resume and job description for personalized answers
- **Flexible Pricing** - Free trial, pay-per-use ($7.99), or unlimited subscription ($19.99/month)

## 📋 Requirements

- macOS 14.0 (Sonoma) or later
- Microphone access
- Speech recognition permissions
- API key (Anthropic or OpenAI)

## 🚀 Getting Started

### 1. First Launch Setup

When you first open TocoAce, you'll be prompted to configure your settings:

1. **Select AI Engine**: Choose between Claude 3.5 Sonnet, GPT-4o, or GPT-4 Turbo
2. **Add API Key**: 
   - For Claude: Get your key from [Anthropic Console](https://console.anthropic.com/)
   - For OpenAI: Get your key from [OpenAI Platform](https://platform.openai.com/api-keys)
3. **Upload Resume**: Support for PDF, DOCX, and TXT files
4. **Job Details**: Add position title, company name, level (Junior/Middle/Senior), and job description
5. **Answer Length**: Choose your preferred response length

### 2. Using TocoAce During Interviews

1. **Start Recording**: Click "Start Recording" button (or use microphone icon)
   - Grant microphone and speech recognition permissions when prompted
   - The app will start transcribing in real-time
   
2. **Generate Answers**: 
   - When the interviewer asks a question, wait for transcription to complete
   - Press `Cmd + Space` or click "Generate Answer"
   - AI will generate a contextual response based on your resume and job details
   
3. **Use the Answer**:
   - Read the generated answer naturally
   - Copy to clipboard with "Copy" button
   - Regenerate if needed with "Regenerate" button

### 3. Window Behavior

- **Always On Top**: The window floats above all other apps
- **All Spaces**: Available on all macOS Spaces/Desktops
- **Movable**: Drag anywhere on the window to reposition

## 🎨 UI Components

### Main Interface

- **Top Bar**: 
  - App title
  - Interviews remaining counter
  - Settings button
  
- **Transcription Panel**: Real-time speech-to-text display
- **Control Buttons**: Start/Stop recording, Generate answer
- **Answer Display**: Generated responses with copy/regenerate options

### Settings Panel

Configure all app preferences:
- AI engine selection
- API keys
- Answer length preferences
- Job details and context
- Resume management

### Subscription Panel

Manage your plan:
- View current subscription tier
- Purchase single interviews ($7.99 each)
- Subscribe for unlimited interviews ($19.99/month)
- Restore previous purchases

## 💰 Pricing

| Plan | Price | Interviews | Best For |
|------|-------|-----------|----------|
| **Free Trial** | $0 | 1 interview | Testing the app |
| **Pay-Per-Use** | $7.99 | 1 interview | Occasional users |
| **Monthly Subscription** | $19.99/mo | Unlimited | Active job seekers |

## 🌍 Supported Languages

### UI Languages
- 🇺🇸 English
- 🇷🇺 Russian (Русский)
- 🇰🇿 Kazakh (Қазақша)
- 🇵🇱 Polish (Polski)
- 🇸🇪 Swedish (Svenska)

### Speech Recognition
All 5 languages are supported for real-time transcription.

## 🔒 Privacy & Security

- **On-Device Speech Recognition**: Uses Apple's Speech Recognition Framework
- **Secure API Calls**: All AI requests are made over HTTPS
- **Local Storage**: Settings and resume data stored locally using UserDefaults
- **Sandbox**: App runs in macOS sandbox for enhanced security
- **No Data Collection**: Your interview data never leaves your device (except for AI API calls)

## ⚙️ Technical Details

### Architecture

```
TocoAce/
├── Models/
│   ├── AppSettings.swift          # User preferences & configuration
│   ├── InterviewSession.swift     # Interview history tracking
│   └── SubscriptionStatus.swift   # In-app purchase management
├── Services/
│   ├── SpeechRecognitionManager.swift  # Apple Speech Framework integration
│   ├── AIService.swift                  # Claude & OpenAI API integration
│   ├── SubscriptionManager.swift       # StoreKit 2 implementation
│   └── DocumentParser.swift            # PDF/DOCX resume parsing
├── Views/
│   ├── MainView.swift              # Primary interface
│   ├── SettingsView.swift          # Configuration panel
│   ├── SubscriptionView.swift      # Purchase flow
│   ├── TranscriptionView.swift     # Live transcription display
│   └── AnswerView.swift            # AI response display
└── Utilities/
    └── LocalizationHelper.swift    # Multi-language support
```

### Technologies Used

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Audio**: AVFoundation
- **Speech**: Speech Recognition Framework (Apple)
- **AI APIs**: 
  - Anthropic Claude API
  - OpenAI GPT API
- **Payments**: StoreKit 2
- **Storage**: UserDefaults, FileManager
- **Document Parsing**: PDFKit, NSAttributedString

## 🎯 Use Cases

1. **Technical Interviews** - Get help with coding questions, system design, algorithms
2. **Behavioral Questions** - Generate STAR-method responses
3. **Company Research** - Quick facts about the company and role
4. **Salary Negotiations** - Prepared responses for compensation discussions
5. **General Interview Prep** - Practice with real-time feedback

## ⚠️ Important Notes

- **Ethical Use**: This tool is for preparation and confidence building. Always be honest with interviewers.
- **Internet Required**: AI answer generation requires active internet connection
- **API Costs**: You are responsible for API usage costs with Anthropic/OpenAI
- **Microphone Quality**: Better microphone = better transcription accuracy
- **Background Noise**: Use in quiet environment for best results

## 🐛 Troubleshooting

### Speech Recognition Not Working
- Check microphone permissions in System Settings > Privacy & Security > Microphone
- Enable Speech Recognition in System Settings > Privacy & Security > Speech Recognition
- Restart the app after granting permissions

### AI Generation Fails
- Verify API key is correct
- Check internet connection
- Ensure you have API credits/quota remaining
- Try switching AI engines

### Window Not Staying On Top
- Relaunch the app
- Check macOS window management settings

## 📝 Keyboard Shortcuts

- `Cmd + Space` - Generate Answer
- `Cmd + ,` - Open Settings (when implemented)

## 🔄 Future Features (Roadmap)

- [ ] Interview history review
- [ ] Answer templates library
- [ ] Practice mode with mock questions
- [ ] Multi-language answer generation
- [ ] Team/Company plans
- [ ] Chrome extension for deeper integration
- [ ] Answer quality scoring
- [ ] Custom AI fine-tuning

## 📄 License

Copyright © 2025 TocoAce. All rights reserved.

## 🤝 Support

For support, feature requests, or bug reports, please contact:
- Email: support@tocoace.com (placeholder)
- Website: https://tocoace.com (placeholder)

---

<div align="center">
  <p>Made with ❤️ for job seekers worldwide</p>
  <p><strong>Good luck with your interviews! 🚀</strong></p>
</div>


