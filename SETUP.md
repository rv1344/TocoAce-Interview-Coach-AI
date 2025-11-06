# TocoAce - Setup Instructions

This guide will help you set up the TocoAce Interview Coach AI project in Xcode.

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Apple Developer Account (for testing StoreKit)

## Setup Steps

### 1. Open the Project

1. Open `TocoAce – Interview Coach AI.xcodeproj` in Xcode
2. Wait for Xcode to index the project

### 2. Add Files to Project (If Not Already Added)

If the files are not showing in the Project Navigator, you'll need to add them manually:

1. **Right-click** on the "TocoAce – Interview Coach AI" group in Project Navigator
2. Select **"Add Files to 'TocoAce – Interview Coach AI'..."**
3. Navigate to the project folder and add the following folders:
   - `Models/` (containing AppSettings.swift, InterviewSession.swift, SubscriptionStatus.swift)
   - `Services/` (containing all service files)
   - `Views/` (containing all view files)
   - `Utilities/` (containing LocalizationHelper.swift)
   - `Resources/` (containing localization folders)
4. Make sure **"Copy items if needed"** is checked
5. Select **"Create groups"** (not folder references)
6. Ensure the target checkbox is selected for "TocoAce – Interview Coach AI"

### 3. Configure Localizations

1. Select the **project** in Project Navigator (the blue icon at the top)
2. Select the **TocoAce – Interview Coach AI** project (not the target)
3. Go to the **Info** tab
4. Under **Localizations**, click the **+** button and add:
   - Russian (ru)
   - Kazakh (kk)
   - Polish (pl)
   - Swedish (sv)
   
   (English should already be there)

### 4. Add StoreKit Configuration

1. In Xcode, go to **File > Add Files to "TocoAce – Interview Coach AI"...**
2. Select `Products.storekit`
3. Make sure it's added to the target

To test in-app purchases:
1. Go to **Product > Scheme > Edit Scheme**
2. Select **Run** in the left sidebar
3. Go to the **Options** tab
4. Set **StoreKit Configuration** to `Products.storekit`

### 5. Configure Info.plist

The `Info.plist` file should already be configured, but verify it contains:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>TocoAce needs access to your microphone to transcribe interview questions in real-time.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>TocoAce uses speech recognition to convert your interview questions into text.</string>
```

### 6. Configure Entitlements

Verify `TocoAce___Interview_Coach_AI.entitlements` contains:

```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

### 7. Build Settings

1. Select the **target** "TocoAce – Interview Coach AI"
2. Go to **Build Settings**
3. Verify:
   - **Minimum Deployment**: macOS 14.0
   - **Swift Language Version**: Swift 5

### 8. Code Signing

1. Select the target
2. Go to **Signing & Capabilities**
3. Select your Team
4. Xcode will automatically manage provisioning profiles

## Building the Project

1. Select the scheme **"TocoAce – Interview Coach AI"** in the toolbar
2. Select **"My Mac"** as the destination
3. Press **Cmd + B** to build
4. Press **Cmd + R** to run

## Testing the App

### First Run

1. When the app launches, it will request permissions:
   - **Microphone Access** - Click "OK" in the system dialog
   - **Speech Recognition** - Click "OK" in the system dialog
   
2. The Settings panel will open automatically on first launch

### Configuring Settings

1. Select your AI engine (Claude is recommended for MVP)
2. Enter your API key:
   - **Claude**: Get from https://console.anthropic.com/
   - **OpenAI**: Get from https://platform.openai.com/api-keys
3. Upload a test resume (PDF or DOCX)
4. Fill in job details
5. Click "Done"

### Testing Speech Recognition

1. Click "Start Recording"
2. Grant permissions if prompted
3. Speak into your microphone
4. You should see live transcription appear
5. Click "Stop Recording" when done

### Testing AI Generation

1. After recording some text (or with text in the transcription field)
2. Click "Generate Answer" or press **Cmd + Space**
3. Wait for the AI to generate a response
4. The answer will appear in the Answer Display area

### Testing In-App Purchases (Sandbox)

1. Make sure StoreKit configuration is set in the scheme
2. Click the star icon in the top bar
3. You should see the subscription panel
4. Products will load from `Products.storekit`
5. Test purchasing (in StoreKit sandbox, no real money)

## Common Issues

### Files Not Showing in Xcode

**Solution**: Use "Add Files to..." and make sure target is checked

### Build Errors About Missing Files

**Solution**: 
1. In Project Navigator, find files in red
2. Click on each file
3. In File Inspector (right panel), click the folder icon
4. Relocate the file

### Speech Recognition Not Working

**Solution**:
1. Go to **System Settings > Privacy & Security**
2. Enable **Microphone** for TocoAce
3. Enable **Speech Recognition** for TocoAce
4. Restart the app

### API Calls Failing

**Solution**:
1. Verify API key is correct
2. Check you have credits/quota
3. Verify internet connection
4. Check Console for detailed error messages

### Window Not Floating

**Solution**: The window should automatically float on launch. If not:
1. Check the AppDelegate code in `TocoAce___Interview_Coach_AIApp.swift`
2. Make sure `window.level = .floating` is being called

## Project Structure

```
TocoAce – Interview Coach AI/
├── TocoAce – Interview Coach AI/
│   ├── Models/                    # Data models
│   │   ├── AppSettings.swift
│   │   ├── InterviewSession.swift
│   │   └── SubscriptionStatus.swift
│   ├── Services/                  # Business logic
│   │   ├── SpeechRecognitionManager.swift
│   │   ├── AIService.swift
│   │   ├── SubscriptionManager.swift
│   │   └── DocumentParser.swift
│   ├── Views/                     # UI components
│   │   ├── MainView.swift
│   │   ├── SettingsView.swift
│   │   ├── SubscriptionView.swift
│   │   ├── TranscriptionView.swift
│   │   └── AnswerView.swift
│   ├── Utilities/                 # Helper classes
│   │   └── LocalizationHelper.swift
│   ├── Resources/                 # Localization files
│   │   ├── en.lproj/
│   │   ├── ru.lproj/
│   │   ├── kk.lproj/
│   │   ├── pl.lproj/
│   │   └── sv.lproj/
│   ├── Assets.xcassets/          # Images and colors
│   ├── TocoAce___Interview_Coach_AIApp.swift  # App entry point
│   ├── ContentView.swift         # Legacy view
│   ├── Info.plist               # App configuration
│   ├── TocoAce___Interview_Coach_AI.entitlements
│   └── Products.storekit        # StoreKit configuration
├── README.md
└── SETUP.md (this file)
```

## Next Steps

1. **Test all features** thoroughly
2. **Add custom app icon** in Assets.xcassets
3. **Configure bundle identifier** for your account
4. **Set up App Store Connect** for real in-app purchases
5. **Submit for review** when ready

## Need Help?

If you encounter issues not covered here:
1. Check the Console in Xcode for error messages
2. Use breakpoints to debug
3. Verify all files are included in the target
4. Clean build folder (Cmd + Shift + K) and rebuild

---

Good luck building TocoAce! 🚀


