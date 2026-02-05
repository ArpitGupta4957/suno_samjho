# 🌸 Suno – Samjho  
> 🧠 An AI-powered **mental health screening app** built with **Flutter + Supabase**, designed for culturally-aware, multilingual support.  

---

## 📖 Overview  
**Suno – Samjho** is your **personal mental health companion app** that blends **AI, speech & text analysis, and clinical models** to help detect early signs of depression and anxiety.  

It has been carefully designed with:  
- 🌍 **Cultural sensitivity** (supports 22+ Indian languages & Hinglish)  
- 🔒 **Privacy-first architecture** (encrypted sessions & data protection)  
- 📱 **Accessibility-first approach** (smooth performance on 92% of Android & iOS devices)  

Our goal is simple: **make mental health support affordable, accessible, and stigma-free**.  

---

## ✨ Features  

- 🌐 **Multilingual Support** → 22+ Indian languages (Hinglish & code-switching included)  
- 🎙 **Voice & Text Screening** → Detect emotional state in real-time  
- 🤖 **AI Chatbot** → Built on CBT, ACT & mindfulness frameworks  
- 🔑 **Authentication** → Secure sign-in with Supabase (Google & Email)  
- 🚨 **Crisis Response** → Real-time risk detection & escalation to professionals  
- 📊 **Dashboard** → Track emotional health stats, mood patterns, and AI suggestions  
- 🔒 **Privacy-First** → Encrypted storage, no compromise on anonymity  

---

## 🏗️ Tech Stack  

**Frontend:** Flutter (Dart)  
**Backend:** Supabase (Auth, DB, Storage) + FastAPI (AI endpoints)  
**AI / NLP Models:** HuggingFace Transformers, IndicBERT, Whisper  
**Database:** Supabase Postgres  
**Other Tools:** Firebase (notifications), Docker, GitHub Actions  

---


## 📸 Screenshots *(Coming Soon)*  

---

## 🚀 Getting Started  

### Prerequisites  

Before you begin, ensure you have the following installed:

| Tool | Version | Installation |
|------|---------|--------------|
| **Flutter SDK** | 3.8.0+ | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | 3.8.1+ | Included with Flutter |
| **Git** | Latest | [git-scm.com](https://git-scm.com/) |
| **Android Studio** (for Android) | Latest | [developer.android.com](https://developer.android.com/studio) |
| **Xcode** (for iOS, macOS only) | 14+ | App Store |
| **Chrome** (for Web) | Latest | [google.com/chrome](https://www.google.com/chrome/) |

Verify your Flutter installation:
```bash
flutter doctor
```

---

### 1️⃣ Clone the Repository  
```bash
git clone https://github.com/your-username/suno-samjho.git
cd suno-samjho
```

### 2️⃣ Install Dependencies  
```bash
flutter pub get
```

### 3️⃣ Configure Supabase & Environment Variables  

This app uses **Supabase** for authentication and database. You'll need to set up your own Supabase project or use the shared development credentials.

#### Option A: Use Shared Dev Credentials (Recommended for Contributors)
Request access to the shared development Supabase project by:
1. Opening an issue with the label `access-request`
2. A maintainer will add you to the dev project and share credentials

#### Option B: Create Your Own Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Navigate to **Settings → API** to find your credentials
4. Enable **Email/Password** and **Google OAuth** in **Authentication → Providers**

#### Create the `.env` File
Create a `.env` file in the project root (this file is gitignored):
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

> ⚠️ **Never commit your `.env` file!** It contains sensitive credentials.

---

### 4️⃣ Run the App  

#### Web (Easiest for Development)
```bash
flutter run -d chrome
```

#### Android
```bash
flutter run -d android
```

#### iOS (macOS only)
```bash
flutter run -d ios
```

#### All Available Devices
```bash
flutter devices       # List available devices
flutter run -d <device_id>
```

---

### 🧪 Running Tests
```bash
flutter test
```

---

## 🧑‍💻 Roadmap  

- [x] UI Wireframes (Onboarding, Dashboard, Chatbot)  
- [x] Supabase Authentication (Google + Email)  
- [ ] Voice-to-Text Pipeline (Whisper API)  
- [ ] Multilingual NLP Analysis (IndicBERT + HuggingFace)  
- [ ] Real-time Risk Scoring & Crisis Protocols  
- [ ] Clinical Trial & Feedback Phase  

---

## 📊 Impact  

- 🌍 Aiming to reach **100M+ underserved Indians** lacking mental health access  
- 📉 Potential **30–50% reduction in depression symptoms** after consistent 6-week usage  
- 🔐 Built on **ethics-first design** principles, prioritizing user privacy, safety, and accessibility  

---

## 🤝 Contributing  

We welcome contributors from **AI, Flutter, healthcare & design** backgrounds!  

### 🏷️ Good First Issues  

New to the project? Look for issues labeled with:

| Label | Description |
|-------|-------------|
| `good first issue` | Beginner-friendly tasks, great for first-time contributors |
| `help wanted` | Issues where we need community help |
| `documentation` | Improve docs, READMEs, or code comments |
| `ui/ux` | Design improvements & accessibility fixes |
| `bug` | Confirmed bugs that need fixing |

**[→ Browse Good First Issues](../../issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)**

---

### 📝 Contribution Workflow

#### 1. Find or Create an Issue
- Browse existing [issues](../../issues) or create a new one
- Comment on the issue to let maintainers know you're working on it
- Wait for assignment before starting (to avoid duplicate work)

#### 2. Fork & Clone
```bash
# Fork via GitHub UI, then:
git clone https://github.com/YOUR-USERNAME/suno-samjho.git
cd suno-samjho
git remote add upstream https://github.com/ORIGINAL-OWNER/suno-samjho.git
```

#### 3. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
# or for bugs:
git checkout -b fix/issue-description
```

#### 4. Make Your Changes
- Follow the existing code style
- Write meaningful commit messages
- Add tests for new features when possible

#### 5. Test Your Changes
```bash
flutter analyze    # Check for lint issues
flutter test       # Run tests
flutter run -d chrome  # Manual testing
```

#### 6. Submit a Pull Request
```bash
git push origin feature/your-feature-name
```
Then open a PR on GitHub with:
- Clear description of what you changed and why
- Reference to the related issue (e.g., `Fixes #123`)
- Screenshots for UI changes

---

### 📂 Project Structure

```
lib/
├── main.dart          # App entry point
├── auth/              # Authentication screens & logic
├── chatbot/           # AI chatbot interface
├── config/            # App configuration & constants
├── home/              # Home/Dashboard screens
├── onboarding/        # Onboarding flow
├── profile/           # User profile management
├── services/          # API & Supabase services
├── splash/            # Splash screen
└── info/              # Info/About screens
```

---

### ✅ Code Style Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) conventions
- Use meaningful variable and function names
- Keep widgets small and focused (prefer composition)
- Add comments for complex logic
- Run `flutter analyze` before committing  

---

## 📜 License  

This project is licensed under the **MIT License**.  
You are free to use, modify, and distribute this software with attribution.  

---

## ⭐ Support  

If you find this project meaningful, please ⭐ the repo and help spread awareness for **mental health tech** 💙.  