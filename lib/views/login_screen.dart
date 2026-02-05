import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorDark, // Deep Dark Purple Background
      body: Column(
        children: [
          // Elegant Header Section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.mainColorDark,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premium Logo
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: AppColors.mainColorDark,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Splitify',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Actionable Form Section (White Card)
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(55),
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(55)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to manage your shared expenses.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),

                      _buildTextField(
                          'EMAIL ADDRESS',
                          Icons.alternate_email_rounded,
                          _emailController,
                          false),
                      const SizedBox(height: 16),
                      _buildTextField('PASSWORD', Icons.lock_outline_rounded,
                          _passwordController, true),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Primary Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainLayout()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColorDark,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Text(
                            'START TRACKING',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: Color(0xFFEFE6EF))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR LOGIN WITH',
                              style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textDisabled,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5),
                            ),
                          ),
                          const Expanded(
                              child: Divider(color: Color(0xFFEFE6EF))),
                        ],
                      ),
                      const SizedBox(height: 32),

                      _buildSocialButton(
                          Icons.g_mobiledata_rounded, 'Continue with Google'),

                      const SizedBox(height: 48),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'New to Splitify? ',
                            style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Create Account',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w800,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.textDisabled,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _isObscured,
            style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: 'Your ${label.toLowerCase()}',
              hintStyle: TextStyle(
                  color: AppColors.textDisabled.withOpacity(0.6), fontSize: 14),
              prefixIcon: Icon(icon,
                  color: AppColors.mainColor.withOpacity(0.4), size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textDisabled,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _isObscured = !_isObscured),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 32),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
