# Awaaz Room V6 deployment checklist

## आपको अपने अकाउंट में करना होगा
1. Firebase project बनाकर Android और iOS apps register करें।
2. project root में `flutterfire configure` चलाकर `lib/firebase_options.dart` generate करें।
3. Firebase Phone Authentication और Firestore enable करें।
4. LiveKit Cloud project बनाएँ या self-hosted LiveKit server deploy करें।
5. Backend hosting पर `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET` और `LIVEKIT_URL` secrets सेट करें।
6. Backend को Firebase Admin के लिए application-default/service-account credential दें। Secret file app ZIP या Git में commit न करें।
7. Backend को HTTPS पर deploy करें और Flutter app में उसका URL सेट करें।
8. Android तथा iOS microphone permissions और signing configuration जोड़ें।
9. दो वास्तविक phones पर OTP, room join, mute, disconnect और weak-network tests करें।

## आउटपुट
Flutter project से Android APK/AAB और iOS archive बनेंगे। iOS archive/signing के लिए Apple Developer account और macOS/Xcode आवश्यक होंगे।
