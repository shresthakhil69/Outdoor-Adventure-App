import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Home screen displayed after successful user sign-in.
/// Displays the user's name, email, profile picture, and a Sign Out button.
class HomeScreen extends StatelessWidget {
  final AuthService? authService;

  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final service = authService ?? AuthService();
    final user = service.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Trail Pass Dashboard',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.brandText,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Photo or fallback icon
                  if (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(user.photoURL!),
                    )
                  else
                    const CircleAvatar(
                      radius: 44,
                      backgroundColor: Color(0xFFF3F4F0),
                      child: Icon(
                        Icons.person,
                        size: 44,
                        color: Color(0xFF1E4D2B),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // User Display Name
                  Text(
                    user?.displayName ?? 'Trail Navigator',
                    textAlign: TextAlign.center,
                    style: AppText.style(
                      size: 20,
                      weight: FontWeight.w700,
                      color: const Color(0xFF191C1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // User Email Address
                  Text(
                    user?.email ?? 'No email provided',
                    textAlign: TextAlign.center,
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFF414941),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Sign Out Button returning to login screen
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4D2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await service.signOut();
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                      label: Text(
                        'Sign Out',
                        style: AppText.style(
                          size: 14,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
