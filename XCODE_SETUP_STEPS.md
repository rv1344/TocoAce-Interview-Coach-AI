# Quick Xcode Setup Guide

## Step-by-Step Instructions to Add Files to Your Project

### 1. Open the Project
- Launch **Xcode**
- Open `TocoAce – Interview Coach AI.xcodeproj`

### 2. Check Current Files
In the **Project Navigator** (left panel), you should see:
- TocoAce – Interview Coach AIApp.swift ✅
- ContentView.swift ✅
- Assets.xcassets ✅
- TocoAce___Interview_Coach_AI.entitlements ✅

### 3. Add New Folders and Files

If you don't see the Models, Services, Views, Utilities, or Resources folders:

#### Option A: Drag and Drop (Easiest)
1. Open **Finder** and navigate to the project folder
2. Locate these folders:
   - `Models/`
   - `Services/`
   - `Views/`
   - `Utilities/`
   - `Resources/`
3. **Drag each folder** into Xcode's Project Navigator
4. In the dialog that appears:
   - ✅ Check **"Copy items if needed"**
   - ✅ Select **"Create groups"** (not folder references)
   - ✅ Make sure **"TocoAce – Interview Coach AI" target** is checked
5. Click **"Finish"**

#### Option B: Add Files Menu
1. Right-click on "TocoAce – Interview Coach AI" group in Project Navigator
2. Select **"Add Files to 'TocoAce – Interview Coach AI'..."**
3. Navigate to your project folder
4. Select the folders one by one (Models, Services, Views, etc.)
5. Make sure:
   - ✅ **"Copy items if needed"** is checked
   - ✅ **"Create groups"** is selected
   - ✅ Target checkbox is selected
6. Click **"Add"**

### 4. Add Individual Files

Also add these files if they're not already in the project:
- `Info.plist`
- `Products.storekit`

Same process: Right-click → Add Files → Select file → Add

### 5. Verify File Structure

Your Project Navigator should now look like this:

```
TocoAce – Interview Coach AI
├── 📁 Models
│   ├── AppSettings.swift
│   ├── InterviewSession.swift
│   └── SubscriptionStatus.swift
├── 📁 Services
│   ├── AIService.swift
│   ├── DocumentParser.swift
│   ├── SpeechRecognitionManager.swift
│   └── SubscriptionManager.swift
├── 📁 Views
│   ├── AnswerView.swift
│   ├── MainView.swift
│   ├── SettingsView.swift
│   ├── SubscriptionView.swift
│   └── TranscriptionView.swift
├── 📁 Utilities
│   └── LocalizationHelper.swift
├── 📁 Resources
│   ├── 📁 en.lproj
│   ├── 📁 ru.lproj
│   ├── 📁 kk.lproj
│   ├── 📁 pl.lproj
│   └── 📁 sv.lproj
├── 📁 Assets.xcassets
├── TocoAce___Interview_Coach_AIApp.swift
├── ContentView.swift
├── Info.plist
├── Products.storekit
└── TocoAce___Interview_Coach_AI.entitlements
```

### 6. Configure Localizations

1. Click on the **project** (blue icon) in Project Navigator
2. Select the **project** (not target) in the editor
3. Go to **Info** tab
4. Under **Localizations**, click **+** to add:
   - Russian (ru)
   - Kazakh (kk)
   - Polish (pl)
   - Swedish (sv)

### 7. Set Up StoreKit Configuration

1. Go to **Product** menu → **Scheme** → **Edit Scheme...**
2. Select **Run** in the left sidebar
3. Go to **Options** tab
4. Under **StoreKit Configuration**, select `Products.storekit`
5. Click **Close**

### 8. Verify Info.plist Configuration

1. Click on `Info.plist` in Project Navigator
2. Verify these keys exist:
   - **NSMicrophoneUsageDescription**
   - **NSSpeechRecognitionUsageDescription**
   - **LSMinimumSystemVersion** = 14.0
   - **CFBundleLocalizations** = array with en, ru, kk, pl, sv

If missing, you can:
- Right-click in the plist editor → **Add Row**
- Or manually edit the XML file

### 9. Check Entitlements

1. Click on `TocoAce___Interview_Coach_AI.entitlements`
2. Verify these capabilities:
   - **App Sandbox** = YES
   - **Audio Input** = YES
   - **Outgoing Connections (Client)** = YES
   - **User Selected File** (Read Only) = YES

### 10. Configure Code Signing

1. Select the **target** "TocoAce – Interview Coach AI"
2. Go to **Signing & Capabilities** tab
3. Under **Team**, select your Apple Developer account
4. Xcode will handle the rest automatically

### 11. Build the Project

1. Select scheme: **TocoAce – Interview Coach AI** (top toolbar)
2. Select destination: **My Mac** (next to scheme)
3. Press **Cmd + B** to build

### 12. Fix Any Build Errors

If you see red errors:

**"Cannot find 'MainView' in scope"**
- Solution: Make sure MainView.swift is added to the target
- Click on the file → File Inspector → check target box

**"Missing required module"**
- Solution: Clean build folder (Cmd + Shift + K)
- Then rebuild (Cmd + B)

**Missing localization files**
- Solution: Make sure Resources folder is properly added
- Check that .lproj folders are included

### 13. Run the App

Once it builds successfully:
1. Press **Cmd + R** to run
2. Grant permissions when prompted:
   - Microphone access
   - Speech recognition
3. Configure settings (API key, resume, etc.)
4. Test the features!

## Troubleshooting

### Files appear in red
- Click on the file
- In **File Inspector** (right panel), click the folder icon
- Relocate the file to its correct location

### "No such module" errors
- Clean build folder: **Product** → **Clean Build Folder**
- Close and reopen Xcode
- Delete DerivedData: `~/Library/Developer/Xcode/DerivedData`

### App crashes on launch
- Check Console in Xcode for error messages
- Verify all files are properly added to target
- Make sure Info.plist is configured correctly

### StoreKit not working
- Verify Products.storekit is in the project
- Check scheme settings have StoreKit config selected
- Make sure you're testing in Debug mode

## Quick Test Commands

After successful build:

1. **Test Speech Recognition**:
   - Click "Start Recording"
   - Speak into microphone
   - Verify transcription appears

2. **Test AI Generation**:
   - Add API key in Settings
   - Record or type some text
   - Click "Generate Answer" (Cmd+Space)
   - Wait for response

3. **Test Subscriptions**:
   - Click star icon (top right)
   - Verify products load
   - Try test purchase (sandbox)

## Need Help?

Check these files for more info:
- `README.md` - Full feature documentation
- `SETUP.md` - Detailed setup guide
- `API_KEYS_EXAMPLE.txt` - How to get API keys
- `CHECKLIST.md` - Testing checklist

---

**You're all set! Happy building! 🚀**


