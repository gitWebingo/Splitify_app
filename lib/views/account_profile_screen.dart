import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'account_settings_screen.dart';
import '../controllers/data_controller.dart';

class AccountProfileScreen extends StatelessWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataController>(builder: (context, controller, _) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  controller.currentUser.profilePic != null
                                      ? NetworkImage(
                                          controller.currentUser.profilePic!)
                                      : null,
                              child: controller.currentUser.profilePic == null
                                  ? Text(controller.currentUser.name[0],
                                      style: GoogleFonts.outfit(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.mainColor))
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(controller.currentUser.name,
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5)),
                          Text(controller.currentUser.email,
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_suggest_rounded,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AccountSettingsScreen()));
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildProBanner(),
                    const SizedBox(height: 32),
                    _buildMenuSection('ACCOUNT SETTINGS', [
                      _buildMenuItem(
                          Icons.person_outline_rounded, 'Personal Information',
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AccountSettingsScreen()));
                      }),
                      _buildMenuItem(Icons.notifications_none_rounded,
                          'Notifications', () {}),
                      _buildMenuItem(
                          Icons.security_rounded, 'Privacy & Security', () {}),
                    ]),
                    const SizedBox(height: 24),
                    _buildMenuSection('PREFERENCES', [
                      _buildMenuItem(Icons.language_rounded, 'Language', () {}),
                      _buildMenuItem(
                          Icons.color_lens_outlined, 'Appearance', () {},
                          trailing: 'Light'),
                    ]),
                    const SizedBox(height: 24),
                    _buildMenuSection('SUPPORT', [
                      _buildMenuItem(
                          Icons.help_outline_rounded, 'Help Center', () {}),
                      _buildMenuItem(
                          Icons.info_outline_rounded, 'About Splitify', () {}),
                    ]),
                    const SizedBox(height: 48),
                    Text('Version 1.2.0 (Build 42)',
                        style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textDisabled,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.mainColor.withOpacity(0.12),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.mainColor.withOpacity(0.1)),
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AppColors.mainColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text('Splitify Pro',
                  style: GoogleFonts.outfit(
                      color: AppColors.mainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
              'Unlock zero ads, cloud backup and unlimited groups with the Pro plan.',
              style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Get Premium',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDisabled,
                  letterSpacing: 1.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {String? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.mainColor, size: 23),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            const Spacer(),
            if (trailing != null)
              Text(trailing,
                  style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textDisabled,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textDisabled, size: 28),
          ],
        ),
      ),
    );
  }
}
