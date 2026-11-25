import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outdoor_adventure/screens/home_screen.dart';
import 'package:outdoor_adventure/screens/login_screen.dart';
import 'package:outdoor_adventure/screens/register_screen.dart';
import 'package:outdoor_adventure/services/auth_service.dart';

class _FakeUser extends Fake implements User {
  @override
  final String? displayName;

  @override
  final String? email;

  @override
  String? get photoURL => null;

  _FakeUser({this.displayName, this.email});
}

class _FakeAdditionalUserInfo extends Fake implements AdditionalUserInfo {
  @override
  final bool isNewUser;

  _FakeAdditionalUserInfo({required this.isNewUser});
}

class _FakeUserCredential extends Fake implements UserCredential {
  @override
  final User? user;

  @override
  final AdditionalUserInfo? additionalUserInfo;

  _FakeUserCredential({
    required this.user,
    required this.additionalUserInfo,
  });
}

class _StubAuthService extends AuthService {
  UserCredential? googleResult;
  Object? googleError;
  int signInCalls = 0;
  User? signedInUser;

  _StubAuthService() : super(isWeb: false);

  @override
  User? get currentUser => signedInUser;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    signInCalls++;
    if (googleError != null) throw googleError!;
    signedInUser = googleResult?.user;
    return googleResult;
  }

  @override
  Future<void> signOut() async {
    signedInUser = null;
  }
}

Widget _buildTestApp({
  required Widget home,
  required _StubAuthService authService,
}) {
  return MaterialApp(
    home: home,
    routes: {
      '/login': (_) => LoginScreen(authService: authService),
      '/register': (_) => RegisterScreen(authService: authService),
      '/home': (_) => HomeScreen(authService: authService),
      '/level-interest': (_) => const Scaffold(
            body: Center(child: Text('Level & Interest Screen')),
          ),
    },
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Continue with Google UI flow', () {
    testWidgets(
        'LoginScreen routes new Google user to /level-interest without password',
        (tester) async {
      final authService = _StubAuthService()
        ..googleResult = _FakeUserCredential(
          user: _FakeUser(displayName: 'Tenzing', email: 'tenzing@example.com'),
          additionalUserInfo: _FakeAdditionalUserInfo(isNewUser: true),
        );

      await tester.pumpWidget(
        _buildTestApp(
          home: LoginScreen(authService: authService),
          authService: authService,
        ),
      );

      final googleBtn = find.text('Continue with Google');
      await tester.ensureVisible(googleBtn);
      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      expect(authService.signInCalls, 1);
      expect(find.text('Level & Interest Screen'), findsOneWidget);
    });

    testWidgets(
        'LoginScreen routes returning Google user to HomeScreen without password',
        (tester) async {
      final authService = _StubAuthService()
        ..googleResult = _FakeUserCredential(
          user: _FakeUser(
            displayName: 'Pasang Lhamu',
            email: 'pasang@example.com',
          ),
          additionalUserInfo: _FakeAdditionalUserInfo(isNewUser: false),
        );

      await tester.pumpWidget(
        _buildTestApp(
          home: LoginScreen(authService: authService),
          authService: authService,
        ),
      );

      final googleBtn = find.text('Continue with Google');
      await tester.ensureVisible(googleBtn);
      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      expect(authService.signInCalls, 1);
      expect(find.text('Trail Pass Dashboard'), findsOneWidget);
      expect(find.text('Pasang Lhamu'), findsOneWidget);
      expect(find.text('pasang@example.com'), findsOneWidget);
    });

    testWidgets('LoginScreen shows cancellation message when user cancels',
        (tester) async {
      final authService = _StubAuthService()..googleResult = null;

      await tester.pumpWidget(
        _buildTestApp(
          home: LoginScreen(authService: authService),
          authService: authService,
        ),
      );

      final googleBtn = find.text('Continue with Google');
      await tester.ensureVisible(googleBtn);
      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      expect(find.text('Google Sign-In was cancelled.'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('LoginScreen shows real error when GoogleSignInException thrown',
        (tester) async {
      final authService = _StubAuthService()
        ..googleError = const GoogleSignInException(
          'Google Sign-In is not enabled in Firebase Authentication.',
        );

      await tester.pumpWidget(
        _buildTestApp(
          home: LoginScreen(authService: authService),
          authService: authService,
        ),
      );

      final googleBtn = find.text('Continue with Google');
      await tester.ensureVisible(googleBtn);
      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      expect(
        find.text('Google Sign-In is not enabled in Firebase Authentication.'),
        findsOneWidget,
      );
      expect(find.text('Google Sign-In was cancelled.'), findsNothing);
    });

    testWidgets(
        'RegisterScreen allows Google Sign-Up without entering password',
        (tester) async {
      final authService = _StubAuthService()
        ..googleResult = _FakeUserCredential(
          user: _FakeUser(displayName: 'Maya', email: 'maya@example.com'),
          additionalUserInfo: _FakeAdditionalUserInfo(isNewUser: true),
        );

      await tester.pumpWidget(
        _buildTestApp(
          home: RegisterScreen(authService: authService),
          authService: authService,
        ),
      );

      final googleBtn = find.text('Sign up with Google');
      await tester.ensureVisible(googleBtn);
      await tester.tap(googleBtn);
      await tester.pumpAndSettle();

      expect(authService.signInCalls, 1);
      expect(find.text('Level & Interest Screen'), findsOneWidget);
    });
  });
}
