import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'main_layout.dart';

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
      title: 'Splitting the costs among friends is easy!',
      subtitle:
          'Add costs, create groups with your friends and divide costs with them!',
      image: Icons.account_balance_wallet_rounded,
    ),
    OnboardingData(
      title: 'Scan the bill',
      subtitle: 'Add costs is easy with a scan with further cost editing.',
      image: Icons.qr_code_scanner_rounded,
    ),
    OnboardingData(
      title: 'Send notifications about a debt',
      subtitle:
          'Send debt notifications to your friends directly in the app or in messengers.',
      image: Icons.notifications_active_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Lime Background Shape
          Positioned(
            top: -100,
            left: -50,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.elliptical(400, 150)),
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Bottom Navigation (Skip, Dots, Next)
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _completeOnboarding(),
                  child: const Text('Skip',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 16)),
                ),

                // Indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.black
                            : Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),

                // Next Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Column(
      children: [
        const SizedBox(height: 100),
        // Phone Mockup Simulation
        Container(
          width: 250,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.black, width: 8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Icon(data.image, size: 80, color: Colors.black),
              const SizedBox(height: 20),
              Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.grey.shade100),
              const SizedBox(height: 10),
              Container(height: 12, width: 150, color: Colors.grey.shade100),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2D),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ],
    );
  }

  void _completeOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData image;

  OnboardingData(
      {required this.title, required this.subtitle, required this.image});
}
