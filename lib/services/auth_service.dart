import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// User-facing exception thrown when Google Sign-In fails due to
/// configuration, network, or provider errors (as opposed to user cancellation).
class GoogleSignInException implements Exception {
  final String message;
  const GoogleSignInException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth? _auth;
  final GoogleSignIn? _googleSignIn;
  final bool _isWeb;

  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    bool? isWeb,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _isWeb = isWeb ?? kIsWeb;

  FirebaseAuth get _authInstance => _auth ?? FirebaseAuth.instance;
  GoogleSignIn get _googleSignInInstance => _googleSignIn ?? GoogleSignIn();

  User? get currentUser => _authInstance.currentUser;

  /// Signs in with Google without requiring the user to create an app password.
  ///
  /// Returns `null` if the user cancels the Google prompt or closes the web popup.
  /// Throws [GoogleSignInException] for actual authentication/configuration failures.
  Future<UserCredential?> signInWithGoogle() async {
    if (_isWeb) {
      return _signInWithGoogleWeb();
    }
    return _signInWithGoogleMobile();
  }

  Future<UserCredential?> _signInWithGoogleWeb() async {
    try {
      final provider = GoogleAuthProvider();
      return await _authInstance.signInWithPopup(provider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return null;
      }
      throw GoogleSignInException(_friendlyFirebaseMessage(e));
    }
  }

  Future<UserCredential?> _signInWithGoogleMobile() async {
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignInInstance.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw const GoogleSignInException(
          'Google Sign-In did not return authentication tokens. '
          'Verify Firebase OAuth configuration.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _authInstance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw GoogleSignInException(_friendlyFirebaseMessage(e));
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled' || e.code == 'canceled') {
        return null;
      }
      throw GoogleSignInException(_friendlyPlatformMessage(e));
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    return await _authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    if (!_isWeb) {
      try {
        await _googleSignInInstance.signOut();
      } catch (_) {
        // Ignore if user was not signed in via GoogleSignIn.
      }
    }
    await _authInstance.signOut();
  }

  String _friendlyFirebaseMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Google Sign-In is not enabled in Firebase Authentication.';
      case 'popup-blocked':
        return 'Sign-in popup was blocked by your browser. Allow popups and try again.';
      case 'user-disabled':
        return 'This Google account has been disabled.';
      default:
        return e.message ?? 'Google Sign-In failed (${e.code}).';
    }
  }

  String _friendlyPlatformMessage(PlatformException e) {
    final msg = e.message ?? '';
    if (msg.contains('ApiException: 10') ||
        (e.code == 'sign_in_failed' && msg.contains('10'))) {
      return 'Google Sign-In is not configured for this Android app '
          '(missing SHA-1 / OAuth client in Firebase).';
    }
    if (e.code == 'network_error') {
      return 'Network error. Check your internet connection and try again.';
    }
    return msg.isNotEmpty ? msg : 'Google Sign-In failed (${e.code}).';
  }
}
