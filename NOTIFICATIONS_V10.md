# V10 notifications and API protection

## जोड़ा गया
- Android और iOS के लिए Firebase Messaging dependency
- Notification permission request
- Device token save तथा token refresh handling
- Foreground message और notification-open streams
- LiveKit token endpoint पर rate limiting
- Room endpoint पर rate limiting
- Device tokens के लिए restrictive Firestore rules

## Console setup
1. Firebase Cloud Messaging configuration पूरा करें।
2. Xcode में Push Notifications तथा Background Modes में Remote notifications enable करें।
3. Firebase में APNs authentication key upload करें।
4. Android test device या Google APIs वाले emulator का उपयोग करें।
5. Login के बाद `NotificationService.initialize()` call करें।
6. पहले Firebase console से test notification भेजकर delivery जाँचें।

Push भेजने वाला trusted backend अभी अलग से लागू करना बाकी है। Client को Firebase Admin credentials नहीं दिए जाने चाहिए।
