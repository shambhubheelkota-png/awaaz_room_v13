import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'phone_login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.signedInBuilder});
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == null) {
          return PhoneLoginScreen(onSignedIn: () {});
        }
        return signedInBuilder(context);
      },
    );
  }
}
