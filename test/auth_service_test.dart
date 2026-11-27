import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outdoor_adventure/services/auth_service.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {
  UserCredential? credentialResult;
  Object? errorToThrow;
  AuthCredential? lastCredential;
  AuthProvider? lastPopupProvider;
  bool signedOut = false;

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    lastCredential = credential;
    if (errorToThrow != null) throw errorToThrow!;
    return credentialResult!;
  }

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async {
    lastPopupProvider = provider;
    if (errorToThrow != null) throw errorToThrow!;
    return credentialResult!;
  }

  @override
  Future<void> signOut() async {
    signedOut = true;
  }
}

class _FakeGoogleSignIn extends Fake implements GoogleSignIn {
  GoogleSignInAccount? accountResult;
  Object? errorToThrow;
  bool signedOut = false;

  @override
  Future<GoogleSignInAccount?> signIn() async {
    if (errorToThrow != null) throw errorToThrow!;
    return accountResult;
  }

  @override
  Future<GoogleSignInAccount?> signOut() async {
    signedOut = true;
    return null;
  }
}

class _FakeGoogleSignInAccount extends Fake implements GoogleSignInAccount {
  final GoogleSignInAuthentication _auth;
  _FakeGoogleSignInAccount(this._auth);

  @override
  Future<GoogleSignInAuthentication> get authentication async => _auth;
}

class _FakeGoogleSignInAuth extends Fake implements GoogleSignInAuthentication {
  @override
  final String? idToken;

  @override
  final String? accessToken;

  _FakeGoogleSignInAuth({this.idToken, this.accessToken});
}

class _FakeUserCredential extends Fake implements UserCredential {}

void main() {
  group('AuthService.signInWithGoogle (mobile)', () {
    test('returns UserCredential when GoogleSignIn succeeds', () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..credentialResult = _FakeUserCredential();
      final googleSignIn = _FakeGoogleSignIn()
        ..accountResult = _FakeGoogleSignInAccount(
          _FakeGoogleSignInAuth(idToken: 'id-tok', accessToken: 'acc-tok'),
        );

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: googleSignIn,
        isWeb: false,
      );

      final result = await service.signInWithGoogle();
      expect(result, isNotNull);
      expect(firebaseAuth.lastCredential, isA<OAuthCredential>());
    });

    test('returns null when user cancels GoogleSignIn', () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final googleSignIn = _FakeGoogleSignIn()..accountResult = null;

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: googleSignIn,
        isWeb: false,
      );

      final result = await service.signInWithGoogle();
      expect(result, isNull);
    });

    test('throws GoogleSignInException when both tokens are null', () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final googleSignIn = _FakeGoogleSignIn()
        ..accountResult = _FakeGoogleSignInAccount(
          _FakeGoogleSignInAuth(idToken: null, accessToken: null),
        );

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: googleSignIn,
        isWeb: false,
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(isA<GoogleSignInException>()),
      );
    });

    test('maps ApiException: 10 PlatformException to friendly message',
        () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final googleSignIn = _FakeGoogleSignIn()
        ..errorToThrow = PlatformException(
          code: 'sign_in_failed',
          message: 'com.google.android.gms.common.api.ApiException: 10: ',
        );

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: googleSignIn,
        isWeb: false,
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(
          isA<GoogleSignInException>().having(
            (e) => e.message,
            'message',
            contains('SHA-1'),
          ),
        ),
      );
    });

    test('signOut signs out from both GoogleSignIn and FirebaseAuth on mobile',
        () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final googleSignIn = _FakeGoogleSignIn();

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: googleSignIn,
        isWeb: false,
      );

      await service.signOut();
      expect(googleSignIn.signedOut, isTrue);
      expect(firebaseAuth.signedOut, isTrue);
    });
  });

  group('AuthService.signInWithGoogle (web)', () {
    test('calls signInWithPopup and returns UserCredential', () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..credentialResult = _FakeUserCredential();

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: _FakeGoogleSignIn(),
        isWeb: true,
      );

      final result = await service.signInWithGoogle();
      expect(result, isNotNull);
      expect(firebaseAuth.lastPopupProvider, isA<GoogleAuthProvider>());
    });

    test('returns null when web popup is closed by user', () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..errorToThrow = FirebaseAuthException(code: 'popup-closed-by-user');

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: _FakeGoogleSignIn(),
        isWeb: true,
      );

      final result = await service.signInWithGoogle();
      expect(result, isNull);
    });

    test('throws GoogleSignInException when popup-blocked', () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..errorToThrow = FirebaseAuthException(code: 'popup-blocked');

      final service = AuthService(
        auth: firebaseAuth,
        googleSignIn: _FakeGoogleSignIn(),
        isWeb: true,
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(isA<GoogleSignInException>()),
      );
    });
  });
}
