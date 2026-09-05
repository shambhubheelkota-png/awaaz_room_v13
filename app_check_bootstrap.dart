import 'package:firebase_app_check/firebase_app_check.dart';

class AppCheckBootstrap {
  static Future<void> activate() async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );
  }
}
