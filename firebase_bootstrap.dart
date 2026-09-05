import 'package:firebase_core/firebase_core.dart';

class FirebaseBootstrap {
  static Future<void> initialize() async {
    // After running `flutterfire configure`, replace this with:
    // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
    await Firebase.initializeApp();
  }
}
