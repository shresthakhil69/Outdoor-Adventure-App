import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Shared handler for passwordless Google Sign-In from Login and Register screens.
///
/// Routes first-time Google users to `/level-interest` to complete their trail
/// profile, and returning Google users directly to `/home`.
Future<void> runGoogleSignInFlow({
  required BuildContext context,
  required AuthService authService,
}) async {
  try {
    final userCredential = await authService.signInWithGoogle();
    if (!context.mounted) return;

    if (userCredential == null || userCredential.user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Google Sign-In was cancelled.')),
        );
      return;
    }

    final displayName = userCredential.user?.displayName?.trim();
    final welcomeName = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (userCredential.user?.email ?? 'Explorer');

    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    final targetRoute = isNewUser ? '/level-interest' : '/home';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Welcome, $welcomeName!')),
      );
    Navigator.pushReplacementNamed(context, targetRoute);
  } on GoogleSignInException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(e.message)));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
  }
}
