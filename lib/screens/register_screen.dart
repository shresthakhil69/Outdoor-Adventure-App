import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Sign-Up screen for creating a new Trail Pass.
/// Displays name, email, password fields, terms checkbox, and social sign-up.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Service to handle Google Sign-In and Firebase Auth
  final _authService = AuthService();

  // Key used to validate the form inputs
  final _formKey = GlobalKey<FormState>();

  // Text controllers to read user inputs
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variable to toggle password visibility
  bool _obscurePassword = true;

  // State variables for terms and conditions checkbox
  bool _agreedToTerms = false;
  bool _showCheckboxError = false;

  @override
  void dispose() {
    // Clean up controllers when the screen is destroyed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validator for Full Name
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  // Validator for Email Address
  String? _validateEmail(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validator for Security Passcode
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // Handle form submission
  void _onSubmit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _showCheckboxError = !_agreedToTerms;
    });

    if (isFormValid && _agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form is valid'),
        ),
      );
    }
  }

  // Handle Google Sign-In action
  Future<void> _handleGoogleSignIn() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (userCredential != null && userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In was cancelled.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 16),
                  _buildBrandRow(),
                  const SizedBox(height: 20),
                  _buildHeading(),
                  const SizedBox(height: 20),
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildForm(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 24),
                  _buildGoogleButton(),
                  const SizedBox(height: 20),
                  _buildLoginLink(),
                  const SizedBox(height: 20),
                  _buildSecurityPill(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. Top row: Round back button and status pill
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button (48x48 circle)
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F0),
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF191C1A)),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        // Status pill on the right
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F0),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E4D2B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'ALPINE GRID • ACTIVE',
                style: AppText.style(
                  size: 11,
                  weight: FontWeight.w600,
                  color: const Color(0xFF414941),
                  letterSpacing: 0.55,
                  lineHeightPx: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. Brand row: Logo box with app name and subtitle
  Widget _buildBrandRow() {
    return Row(
      children: [
        // Green rounded box for app logo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1E4D2B),
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppShadows.soft,
          ),
          child: const Icon(Icons.terrain, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 10),
        // App name and telemetry subtext
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yak & Trail',
              style: AppText.style(
                size: 16,
                weight: FontWeight.w700,
                color: const Color(0xFF023616),
                letterSpacing: -0.45,
                lineHeightPx: 22,
              ),
            ),
            Text(
              'Nepal Backcountry Telemetry',
              style: AppText.style(
                size: 11,
                weight: FontWeight.w500,
                color: const Color(0xFF414941),
                lineHeightPx: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Main title heading and description
  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Trail Pass',
          style: AppText.style(
            size: 26,
            weight: FontWeight.w700,
            color: const Color(0xFF191C1A),
            letterSpacing: -0.65,
            lineHeightPx: 34,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join Himalayan navigators, sync offline topo maps, and access verified Sherpa trail logs.',
          style: AppText.style(
            size: 14,
            weight: FontWeight.w400,
            color: const Color(0xFF414941),
            lineHeightPx: 19,
          ),
        ),
      ],
    );
  }

  // 4. Info card showing Expedition Network details
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEEB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // TODO: Replace NP circle placeholder with actual partner logo
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'NP',
              style: AppText.style(
                size: 12,
                weight: FontWeight.w700,
                color: const Color(0xFF023616),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Network title & regions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TAAN & NTB Expedition Network',
                  style: AppText.style(
                    size: 12,
                    weight: FontWeight.w700,
                    color: const Color(0xFF191C1A),
                    lineHeightPx: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Solukhumbu • Annapurna • Langtang',
                  style: AppText.style(
                    size: 11,
                    weight: FontWeight.w400,
                    color: const Color(0xFF414941),
                    lineHeightPx: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Topo Sync pill badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sync,
                  size: 13,
                  color: Color(0xFF023616),
                ),
                const SizedBox(width: 4),
                Text(
                  'Topo Sync',
                  style: AppText.style(
                    size: 11,
                    weight: FontWeight.w600,
                    color: const Color(0xFF023616),
                    lineHeightPx: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5, 6, 7 & 8. Form with 3 fields, hint line, checkbox, and main submit button
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field 1: Full Name
          _buildField(
            label: 'Full Name',
            rightNote: 'Official Permit Name',
            hint: 'e.g. Tenzing Norbu',
            prefixIcon: Icons.person_outline,
            controller: _nameController,
            validator: _validateName,
          ),
          const SizedBox(height: 16),
          // Field 2: Email Address
          _buildField(
            label: 'Email Address',
            rightNote: 'For Topo Sync Key',
            hint: 'e.g. trekker@summit.np',
            prefixIcon: Icons.mail_outline,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          // Field 3: Security Passcode
          _buildField(
            label: 'Security Passcode',
            rightNote: 'Min. 8 characters',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xFF414941),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: 6),
          // 6. Password requirement hint line
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 13,
                color: Color(0xFF2C694E),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Requires 8+ characters, 1 number & trail readiness',
                  style: AppText.style(
                    size: 11,
                    weight: FontWeight.w500,
                    color: const Color(0xFF414941),
                    lineHeightPx: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 7. Custom Checkbox row for agreement
          GestureDetector(
            onTap: () {
              setState(() {
                _agreedToTerms = !_agreedToTerms;
                if (_agreedToTerms) _showCheckboxError = false;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: _agreedToTerms
                      ? Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF023616),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I agree to Nepal Backcountry Trail Safety Protocols, AMS acclimatization advisories, and Terms of Service.',
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFF414941),
                      lineHeightPx: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showCheckboxError) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'You must agree to the trail safety protocols',
                style: AppText.style(
                  size: 12,
                  weight: FontWeight.w500,
                  color: const Color(0xFFBA1A1A),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          // 8. Main Action Button: Create Trail Pass
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E4D2B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  spreadRadius: -1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _onSubmit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Trail Pass',
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.1,
                        lineHeightPx: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build labelled text fields according to design specifications
  Widget _buildField({
    required String label,
    required String rightNote,
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppText.style(
                size: 12,
                weight: FontWeight.w600,
                color: const Color(0xFF191C1A),
              ),
            ),
            Text(
              rightNote,
              style: AppText.style(
                size: 11,
                weight: FontWeight.w400,
                color: const Color(0xFF414941),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppText.style(
            size: 14,
            weight: FontWeight.w400,
            color: const Color(0xFF191C1A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.style(
              size: 14,
              weight: FontWeight.w400,
              color: const Color(0xFF717970),
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            prefixIcon: Icon(
              prefixIcon,
              size: 16,
              color: const Color(0xFF414941),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF1E4D2B), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // 9. Centered divider line with text
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE1E3DF),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'OR CONTINUE WITH',
          style: AppText.style(
            size: 11,
            weight: FontWeight.w600,
            color: const Color(0xFF414941),
            letterSpacing: 0.55,
            lineHeightPx: 16,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE1E3DF),
          ),
        ),
      ],
    );
  }

  // 10. White button to sign up with Google
  Widget _buildGoogleButton() {
    // TODO: Replace 'G' placeholder with real Google logo SVG asset
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _handleGoogleSignIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'G',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4285F4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Sign up with Google',
                style: AppText.style(
                  size: 14,
                  weight: FontWeight.w600,
                  color: const Color(0xFF191C1A),
                  letterSpacing: 0.1,
                  lineHeightPx: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 11. Navigation link to Login screen
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have a Trail Pass? ',
          style: AppText.style(
            size: 14,
            weight: FontWeight.w400,
            color: const Color(0xFF414941),
            lineHeightPx: 20,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/login'),
          child: Text(
            'Log In',
            style: AppText.style(
              size: 16,
              weight: FontWeight.w700,
              color: const Color(0xFF023616),
              lineHeightPx: 20,
            ),
          ),
        ),
      ],
    );
  }

  // 12. Encryption security badge at bottom
  Widget _buildSecurityPill() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F0),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 12,
              color: Color(0xFF2C694E),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Protected by 256-bit backcountry sync encryption',
                style: AppText.style(
                  size: 11,
                  weight: FontWeight.w500,
                  color: const Color(0xFF414941),
                  lineHeightPx: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
