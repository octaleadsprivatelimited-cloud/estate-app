# EstateKart Mobile App — Flutter

A production-ready real estate marketplace Flutter app — Android & iOS.

## 📁 Project Structure

```
lib/
├── main.dart                    ← Entry point
├── firebase_options.dart        ← Firebase config (auto-generated)
├── core/
│   ├── theme/app_theme.dart     ← Light/Dark Material 3 theme
│   ├── router/app_router.dart   ← go_router navigation
│   └── constants/              ← App-wide constants
├── models/                      ← PropertyModel, UserModel, etc.
├── providers/                   ← Riverpod providers
├── screens/                     ← All app screens
│   ├── splash/
│   ├── onboarding/
│   ├── auth/                    ← Login, Register
│   ├── home/
│   ├── search/
│   ├── property/                ← Card, Detail
│   ├── wishlist/
│   ├── compare/
│   ├── chat/                    ← List + Room
│   ├── dashboard/               ← Buyer, Seller, Admin
│   ├── blogs/
│   ├── notifications/
│   ├── profile/
│   └── subscription/
└── widgets/                     ← Shared widgets
```

---

## 🚀 Setup Guide (Step by Step)

### Step 1 — Install Flutter SDK
```powershell
# Download from https://flutter.dev/get-started
# Extract to C:\flutter
# Add C:\flutter\bin to system PATH
flutter doctor
```

### Step 2 — Install Android Studio
- Download: https://developer.android.com/studio
- Install with Android SDK (API 34)
- Accept licenses: `flutter doctor --android-licenses`

### Step 3 — Create Firebase Project
1. Go to https://console.firebase.google.com
2. Create project → Enable **Auth + Firestore + Storage**
3. Authentication → Email/Password → Enable
4. Firestore → Create database → Test mode
5. Storage → Get started → Test mode

### Step 4 — Connect Firebase to Flutter (FlutterFire CLI)
```powershell
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Inside the estatekart_mobile folder:
flutterfire configure

# Select your Firebase project → this auto-generates firebase_options.dart
```

### Step 5 — Download google-services.json
1. Firebase Console → Project Settings → Your Apps → Android App
2. Register app with package: `com.estatekart.app`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

### Step 6 — Install dependencies
```powershell
flutter pub get
```

### Step 7 — Run the app
```powershell
# Connect Android device or start emulator first
flutter run
```

### Step 8 — Build release APK
```powershell
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 API Keys to Configure

| Key | Where to Get | Where to Set |
|---|---|---|
| Firebase | Firebase Console | Run `flutterfire configure` |
| Google Maps | console.cloud.google.com | `android/app/src/main/AndroidManifest.xml` |
| Razorpay | razorpay.com | `lib/screens/subscription/subscription_screen.dart` |

---

## ✅ Features Built

| Feature | Status |
|---|---|
| Splash + Onboarding | ✅ |
| Email/Password Auth | ✅ |
| Role Selection (Buyer/Seller/Agent/Builder) | ✅ |
| Home Feed | ✅ |
| Property Search + Filters | ✅ |
| Property Detail (Gallery, Amenities, Map) | ✅ |
| Wishlist | ✅ |
| Compare Properties (up to 3) | ✅ |
| Real-time Chat | ✅ |
| Notifications | ✅ |
| Buyer Dashboard | ✅ |
| Seller Dashboard + Analytics | ✅ |
| Admin Panel (Approve/Reject) | ✅ |
| Blogs | ✅ |
| Subscription Plans (Razorpay stub) | ✅ |
| Profile + Dark Mode toggle | ✅ |
| Call & WhatsApp seller | ✅ |
| Share property | ✅ |

---

## 📱 Publishing to Google Play Store

1. Create keystore: `keytool -genkey -v -keystore estatekart.jks ...`
2. Configure signing in `android/app/build.gradle`
3. Build: `flutter build appbundle --release`
4. Upload `.aab` to Google Play Console

---

## 💰 Free Tools Used

| Tool | Cost |
|---|---|
| Firebase (Spark Plan) | Free |
| Flutter SDK | Free |
| Android Studio | Free |
| Google Play Console | $25 one-time |
