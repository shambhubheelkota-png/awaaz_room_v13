# V8 run instructions

V8 flow का entry point `lib/main_v8.dart` है। Firebase configuration जोड़ने के बाद चलाएँ:

`flutter run -t lib/main_v8.dart --dart-define=API_BASE_URL=https://YOUR_BACKEND --dart-define=LIVEKIT_URL=wss://YOUR_LIVEKIT_HOST`

## पूरा जुड़ा flow
1. Firebase initialize
2. OTP login gate
3. Firestore से live rooms
4. नया room create
5. Firebase ID token से backend LiveKit token
6. LiveKit room connect
7. microphone publish
8. remote participants और speaking indicator
9. mute/unmute और leave

Credentials और generated platform files के बिना build पूर्ण नहीं होगा।
