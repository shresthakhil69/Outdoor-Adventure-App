import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/google_auth_flow.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// S02 - Login. Email login and Google sign-in use Firebase Auth via AuthService.
/// Stories: US02 (email login), US03 (Google). Figma: 390 x 957, padding 16.
class LoginScreen extends StatefulWidget {
  final AuthService? authService;

  const LoginScreen({super.key, this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _authService = widget.authService ?? AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _hidePassword = true;
  bool _cacheSession = true;
  bool _isGoogleLoading = false;
  String? _loginError; // shown for a wrong password, email stays filled in (US02)
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Enter your email';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Enter a valid email address';
  }

  String? _validatePassword(String? v) =>
      (v == null || v.isEmpty) ? 'Enter your password' : null;

  /// Turns a Firebase login error into a message a user understands.
  String _loginMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'No internet connection. Please try again.';
        default:
          return 'Login failed (${error.code}). Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  Future<void> _onLogin() async {
    if (_loading) return;
    setState(() => _loginError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      // The email stays filled in; only the error message appears (US02).
      setState(() => _loginError = _loginMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);
    try {
      await runGoogleSignInFlow(
        context: context,
        authService: _authService,
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _todo(String what) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('$what coming in Sprint 2')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  _brandAndHeading(),
                  _bannerCard(),
                  _form(),
                  _divider(),
                  _socialButtons(),
                  _footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- Top bar: back button (48 circle) + status pill (28 high)
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.textDark),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pill,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(
                  'Alpine Grid • Active'.toUpperCase(),
                  style: AppText.style(
                    size: 11,
                    weight: FontWeight.w600,
                    color: AppColors.textBody,
                    letterSpacing: 0.275,
                    lineHeightPx: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Logo row, heading, subtitle
  Widget _brandAndHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppShadows.soft,
                ),
                // TODO: replace with the exported logo SVG (assets/images/logo.svg)
                child: const Icon(Icons.terrain, size: 20, color: AppColors.white),
              ),
              const SizedBox(width: 8),
              Text(
                'Yak & Trail',
                style: AppText.style(
                  size: 18,
                  weight: FontWeight.w700,
                  color: AppColors.brandText,
                  letterSpacing: -0.45,
                  lineHeightPx: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // 4 + 4 from Figma margins
          Text(
            'Sign In to Trail Pass',
            style: AppText.style(
              size: 26,
              weight: FontWeight.w700,
              color: AppColors.textDark,
              letterSpacing: -0.65,
              lineHeightPx: 34,
            ),
          ),
          const SizedBox(height: 5.4),
          Text(
            'Access offline Himalayan topo maps, verified Sherpa routes, and TIMS permits seamlessly.',
            style: AppText.style(
              size: 14,
              weight: FontWeight.w400,
              color: AppColors.textBody,
              letterSpacing: 0.25,
              lineHeightPx: 23,
            ),
          ),
        ],
      ),
    );
  }

  // ---- Image card 358 x 112, radius 16, green gradient overlay
  Widget _bannerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 112,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Export the photo from Figma as assets/images/login_banner.jpg
              Image.asset(
                'assets/images/login_banner.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceMuted),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xCC023616), Color(0x4D023616), Color(0x00023616)],
                    stops: [0, 0.5, 1],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.shield_outlined, size: 14, color: AppColors.white),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Khumbu & Annapurna Topo Packs Loaded',
                                overflow: TextOverflow.ellipsis,
                                style: AppText.style(
                                  size: 11,
                                  weight: FontWeight.w500,
                                  color: AppColors.white,
                                  letterSpacing: 0.275,
                                  lineHeightPx: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        // Badge text is not visible in the Figma export: check it.
                        child: Text(
                          '3D',
                          style: AppText.style(
                            size: 11,
                            weight: FontWeight.w600,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                            lineHeightPx: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Email, password, cache toggle, Log In button
  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Email Address',
            controller: _emailCtrl,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            hint: 'name@example.com',
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            controller: _passwordCtrl,
            prefixIcon: Icons.lock_outline,
            obscureText: _hidePassword,
            validator: _validatePassword,
            labelTrailing: InkWell(
              onTap: () => Navigator.pushNamed(context, '/forgot'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Forgot password?',
                  style: AppText.style(
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppColors.accent,
                    letterSpacing: 0.5,
                    lineHeightPx: 16,
                  ),
                ),
              ),
            ),
            suffix: IconButton(
              icon: Icon(
                _hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.textBody,
              ),
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
            ),
          ),
          if (_loginError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(_loginError!,
                  style: AppText.style(size: 12, weight: FontWeight.w500, color: Colors.redAccent)),
            ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _cacheSession = !_cacheSession),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _cacheSession ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: _cacheSession ? null : Border.all(color: AppColors.textMuted),
                      boxShadow: AppShadows.soft,
                    ),
                    child: _cacheSession
                        ? const Icon(Icons.check, size: 14, color: AppColors.white)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cache offline session for 30 days',
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w400,
                        color: AppColors.textBody,
                        letterSpacing: 0.25,
                        lineHeightPx: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: PrimaryButton(
              label: _loading ? 'Logging in...' : 'Log In to Trail Pass',
              trailingIcon: Icons.arrow_forward,
              onPressed: _onLogin,
            ),
          ),
        ],
      ),
    );
  }

  // ---- "OR CONTINUE WITH" divider
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.pill)),
          const SizedBox(width: 16),
          Text(
            'OR CONTINUE WITH',
            style: AppText.style(
              size: 11,
              weight: FontWeight.w500,
              color: AppColors.textMuted,
              letterSpacing: 0.55,
              lineHeightPx: 16,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(child: Divider(height: 1, thickness: 1, color: AppColors.pill)),
        ],
      ),
    );
  }

  // ---- Google + Passkey buttons (gap 8)
  Widget _socialButtons() {
    return Column(
      children: [
        SocialButton(
          // TODO: replace with the exported Google "G" SVG (flutter_svg)
          icon: const Text('G',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF4285F4))),
          label: 'Continue with Google',
          isLoading: _isGoogleLoading,
          onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
        ),
        const SizedBox(height: 8),
        SocialButton(
          icon: const Icon(Icons.fingerprint, size: 18, color: AppColors.accent),
          label: 'Passkey & Biometric Sign-in',
          background: AppColors.passkeyBg,
          gap: 8,
          onPressed: () => _todo('Passkey sign-in'),
        ),
      ],
    );
  }

  // ---- Register link + trust line
  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              Text(
                'New to the backcountry?',
                style: AppText.style(
                  size: 14,
                  weight: FontWeight.w400,
                  color: AppColors.textBody,
                  letterSpacing: 0.25,
                  lineHeightPx: 20,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  'Register Trail Pass',
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.brandText,
                    letterSpacing: 0.1,
                    lineHeightPx: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Protected by 256-bit backcountry sync encryption',
                  textAlign: TextAlign.center,
                  style: AppText.style(
                    size: 11,
                    weight: FontWeight.w500,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                    lineHeightPx: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
