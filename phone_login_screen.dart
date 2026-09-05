import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key, required this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  final name = TextEditingController();
  final auth = AuthService();
  final profiles = ProfileService();
  String? verificationId;
  String? message;
  bool busy = false;

  Future<void> sendCode() async {
    setState(() { busy = true; message = null; });
    await auth.sendOtp(
      phoneNumber: phone.text.trim(),
      codeSent: (id) => setState(() { verificationId = id; busy = false; }),
      failed: (error) => setState(() { message = error; busy = false; }),
    );
  }

  Future<void> verify() async {
    if (verificationId == null || name.text.trim().isEmpty) return;
    setState(() => busy = true);
    try {
      final result = await auth.verifyOtp(verificationId: verificationId!, code: otp.text.trim());
      await profiles.saveProfile(
        uid: result.user!.uid,
        displayName: name.text,
        phoneNumber: result.user!.phoneNumber,
      );
      widget.onSignedIn();
    } catch (error) {
      if (mounted) setState(() { message = error.toString(); busy = false; });
    }
  }

  @override
  void dispose() {
    phone.dispose(); otp.dispose(); name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awaaz Room में लॉगिन')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'आपका नाम')),
          const SizedBox(height: 12),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'मोबाइल नंबर', hintText: '+91...'),
          ),
          const SizedBox(height: 12),
          if (verificationId != null)
            TextField(
              controller: otp,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
          if (message != null) Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : (verificationId == null ? sendCode : verify),
            child: Text(busy ? 'कृपया प्रतीक्षा करें' : verificationId == null ? 'OTP भेजें' : 'OTP सत्यापित करें'),
          ),
        ],
      ),
    );
  }
}
