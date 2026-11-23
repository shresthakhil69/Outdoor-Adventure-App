import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Helper service to handle Firebase Authentication and Google Sign-In.
class AuthService {
  // Firebase Auth instance to manage user authentication state
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn instance to prompt Google Account selection
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getter to return the currently signed-in Firebase user (returns null if not signed in)
  User? get currentUser => _auth.currentUser;

  // Sign in with Google account and authenticate with Firebase
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Trigger the Google Sign-In dialog on the device
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in process
        return null;
      }

      // 2. Obtain authentication tokens (accessToken and idToken) from the Google user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new Firebase OAuth credential using the Google tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase using the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Return null if sign-in fails or throws an exception
      return null;
    }
  }

  // Sign out from both Google and Firebase sessions
  Future<void> signOut() async {
    // Sign out from Google account session
    await _googleSignIn.signOut();
    // Sign out from Firebase Auth session
    await _auth.signOut();
  }
}
