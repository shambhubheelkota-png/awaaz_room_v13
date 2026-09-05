# Integration status

## अब code में जुड़ा है
- Firebase authentication-state gate
- Signed-out user को OTP login पर भेजना
- Signed-in user के लिए app shell खोलने का reusable builder
- Firestore live room stream
- Authenticated room creation
- Room title validation
- Environment based backend और LiveKit URLs

## आपके credentials मिलने पर बदलने वाली चीजें
- `flutterfire configure` से generated `firebase_options.dart`
- Firebase Android package और iOS bundle IDs
- LiveKit URL और server secrets
- Hosted backend HTTPS URL
- Android keystore और Apple signing team

## Run example
`flutter run --dart-define=API_BASE_URL=https://api.example.com --dart-define=LIVEKIT_URL=wss://livekit.example.com`
