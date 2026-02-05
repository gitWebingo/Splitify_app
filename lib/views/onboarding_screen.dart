import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Split Expenses\nEffortlessly',
      subtitle:
          'Keep track of shared costs with friends\nand family without the headache.',
      icon: Icons.account_balance_wallet_rounded,
      buttonText: 'Continue Now',
    ),
    OnboardingData(
      title: 'Scan Bills\nInstantly',
      subtitle:
          'Just snap a photo of your receipt\nand let Splitify handle the math.',
      icon: Icons.qr_code_scanner_rounded,
      buttonText: 'Continue Now',
    ),
    OnboardingData(
      title: 'Never Forget\na Debt',
      subtitle:
          'Automatic reminders help everyone stay\non the same page and settle up faster.',
      icon: Icons.notifications_active_rounded,
      buttonText: "Get Started",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorDark, // Restored your Dark Purple
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: _pages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Progress Bars
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 24,
            child: Row(
              children: List.generate(_pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: _currentPage == index ? 24 : 8,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),

          // Skip
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 24,
            child: _currentPage < 2
                ? GestureDetector(
                    onTap: () => _completeOnboarding(),
                    child: Text('Skip',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Column(
      children: [
        // Illustration Space
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  _buildArtisticDecorations(),
                  Icon(data.icon, size: 140, color: Colors.white),
                ],
              ),
            ),
          ),
        ),

        // Bottom Content Card (Matching Screenshot style)
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 52, 40, 32),
              child: Column(
                children: [
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary, // Back to your Text color
                      height: 1.1,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // Premium Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.mainColorDark, // Back to your Purple
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        data.buttonText,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildArtisticDecorations() {
    return Stack(
      children: [
        Positioned(
          top: 30,
          right: 30,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.mainColorLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 50,
          child: Icon(Icons.auto_awesome_rounded,
              color: Colors.white.withOpacity(0.3), size: 32),
        ),
      ],
    );
  }

  void _completeOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonText;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonText,
  });
}
