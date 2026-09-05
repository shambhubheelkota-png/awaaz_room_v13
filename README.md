# Awaaz Room V4

Android और iOS के लिए multi-user voice-room foundation.

## V4 में नया
- LiveKit Flutter client dependency
- Multi-user SFU room connection service
- Backend token endpoint boundary
- Microphone publish और mute/unmute methods
- Remote participant collection
- Secrets को mobile app से बाहर रखने वाली `.env.example`

## सुरक्षा के कारण जानबूझकर अधूरा भाग
`backend/src/token-provider.js` कोई नकली या असुरक्षित token नहीं बनाता। Server पर official LiveKit server SDK install करके token generation लागू करें। `LIVEKIT_API_SECRET` कभी Flutter app में न रखें।

## चलाने से पहले
1. Flutter और platform projects generate करें, यदि वे ZIP में मौजूद न हों: `flutter create .`
2. `flutter pub get` चलाएँ।
3. LiveKit Cloud या self-hosted LiveKit server तैयार करें।
4. Backend में official LiveKit server SDK और token provider लागू करें।
5. `.env.example` से server environment variables सेट करें।
6. Android microphone permissions और iOS `NSMicrophoneUsageDescription` जोड़ें।
7. `LiveAudioRoomService.connect` को Room screen से call करें।

## Production checklist
Authenticated users, short-lived scoped tokens, TURN/TLS, moderation, block/report, rate limiting, audit logs, privacy policy और device testing आवश्यक हैं।

## V5 में नया
- Firebase Phone OTP authentication service
- OTP login UI
- Firestore user profile service
- शुरुआती Firestore security rules
- Project-specific Firebase configuration के लिए setup guide

`lib/firebase_options.dart` जानबूझकर शामिल नहीं है। इसे आपके Firebase project के लिए `flutterfire configure` से generate करना होगा।

## V6 में नया
- Official LiveKit Node server SDK से short-lived room token generation
- Firebase ID token verification middleware
- Mobile client से authenticated token request
- LiveKit identity के रूप में Firebase UID, phone/email जैसी PII नहीं
- Deployment checklist

यह ZIP source project है। Firebase, LiveKit, app signing और hosting credentials आपके अपने accounts से जोड़ने के बाद ही installable release build बनेगा।

## V7 में नया
- Firebase auth-state gate
- Firestore live rooms repository
- केवल signed-in user द्वारा room creation
- Environment based API और LiveKit configuration
- Integration status document

अगली wiring में मौजूदा HomeScreen को `RoomRepository.watchRooms()` से और Live Room screen को `LiveAudioRoomService` से जोड़ना है।

## V8 में नया
- Firestore Home screen और live room list
- Room create करके तुरंत join
- Firebase-authenticated LiveKit token request
- LiveKit connect, microphone publish, participant list व speaking indicator
- Mute/unmute और leave controls
- `main_v8.dart` integrated entry point

## V9 में नया
- Firebase App Check bootstrap
- Raise-hand state service
- Room reporting service
- कठोर Firestore moderation rules
- Security rollout instructions

## V10 में नया
- Firebase push-notification client foundation
- Device token registration और refresh
- Notification interaction streams
- Backend API rate limiting
- Device-token Firestore security rules

## V11 में नया
- Trusted backend से room invitation notifications
- Firebase Admin multicast sending
- Invalid notification-token cleanup
- Authenticated Flutter invite client
- Notification tap से room routing foundation

## V12 में नया
- User name prefix search
- Invite people bottom-sheet UI
- Block और unblock service
- Host-only invitation authorization
- Block-list invitation enforcement
- Updated Firestore rules
