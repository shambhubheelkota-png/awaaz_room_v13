# V9 security and moderation

## जोड़ा गया
- Firebase App Check bootstrap for Android and Apple
- Room report creation with reason validation
- Raise-hand participant state
- Firestore rules that prevent clients from reading reports
- Participants can update only their own state

## लागू करने का क्रम
1. Firebase console में Android के लिए Play Integrity और Apple के लिए DeviceCheck/App Attest register करें।
2. Firebase initialize होने के बाद और Firestore/Auth उपयोग से पहले `AppCheckBootstrap.activate()` call करें।
3. पहले metrics monitor करें, फिर Firebase products पर enforcement enable करें।
4. `firestore.rules.v9` को review करके deploy करें।
5. Reports देखने और कार्रवाई करने के लिए अलग privileged admin backend बनाएँ। Client app को report-reading अधिकार न दें।
