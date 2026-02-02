import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import 'account_settings_screen.dart';
import '../controllers/data_controller.dart';

class AccountProfileScreen extends StatelessWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Consumer<DataController>(
                      builder: (context, controller, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                controller.currentUser.profilePic != null
                                    ? NetworkImage(
                                        controller.currentUser.profilePic!)
                                    : const NetworkImage(
                                        'https://i.pravatar.cc/150?u=nipa'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(controller.currentUser.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        Text(controller.currentUser.email,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ],
                    );
                  }),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountSettingsScreen()));
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProCard(),
                  const SizedBox(height: 24),
                  _buildMenuSection('Quick Actions', [
                    _buildMenuItem(Icons.qr_code_scanner_rounded,
                        'Scan QR Code', AppColors.primaryGradient),
                    _buildMenuItem(Icons.diamond_rounded, 'Upgrade to Pro',
                        AppColors.accentGradient),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuSection('Settings', [
                    _buildMenuItem(
                        Icons.notifications_rounded, 'Notifications', null),
                    _buildMenuItem(
                        Icons.lock_rounded, 'Privacy & Security', null),
                    _buildMenuItem(Icons.language_rounded, 'Language', null),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuSection('Support', [
                    _buildMenuItem(Icons.star_rounded, 'Rate App', null),
                    _buildMenuItem(Icons.help_rounded, 'Help Center', null),
                  ]),
                  const SizedBox(height: 40),
                  const Text('Splitify v1.0.0',
                      style: TextStyle(
                          color: AppColors.textDisabled, fontSize: 12)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text('Splitify Pro',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Unlock premium features and advanced analytics',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF8B5CF6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Learn More',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, LinearGradient? gradient) {
    return ListTile(
      leading: gradient != null
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            )
          : Icon(icon, color: AppColors.textSecondary),
      title: Text(title,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textDisabled),
      onTap: () {},
    );
  }
}
