# Firebase setup

1. Firebase project बनाएँ और Android तथा iOS apps register करें।
2. FlutterFire CLI install करके project root में `flutterfire configure` चलाएँ।
3. इससे generated `lib/firebase_options.dart` मिलेगा।
4. `main.dart` में `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` को `runApp` से पहले call करें।
5. Firebase Authentication में Phone provider enable करें।
6. Firestore database बनाएँ और `firestore.rules` deploy करें।
7. Android SHA fingerprints तथा iOS APNs configuration को Firebase console में पूरा करें।
8. वास्तविक devices पर OTP test करें।

Generated Firebase configuration इस ZIP में शामिल नहीं है क्योंकि वह आपके Firebase project की पहचान पर निर्भर करती है।
