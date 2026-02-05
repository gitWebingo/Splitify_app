import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user =
        Provider.of<DataController>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                leading: const BackButton(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Account Settings',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      )),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('PROFILE INFORMATION'),
                      const SizedBox(height: 16),
                      _buildEditableCard(
                        'Full Name',
                        _nameController,
                        Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildEditableCard(
                        'Email Address',
                        _emailController,
                        Icons.email_outlined,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('PREFERENCES'),
                      const SizedBox(height: 16),
                      _buildSelectCard(
                        'Default Currency',
                        'INR (₹)',
                        Icons.payments_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildSelectCard(
                        'Language',
                        'English (India)',
                        Icons.language_rounded,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('SECURITY & PRIVACY'),
                      const SizedBox(height: 16),
                      _buildToggleCard(
                        'Friend Suggestions',
                        'Allow Splitify to suggest you to friends',
                        Icons.people_outline_rounded,
                        true,
                      ),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textDisabled,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildEditableCard(
      String label, TextEditingController controller, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.mainColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
                TextField(
                  controller: controller,
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textDisabled),
        ],
      ),
    );
  }

  Widget _buildToggleCard(
      String title, String subtitle, IconData icon, bool value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textDisabled,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (v) {},
            activeTrackColor: AppColors.mainColor.withOpacity(0.3),
            activeColor: AppColors.mainColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.0), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Provider.of<DataController>(context, listen: false)
                .updateUser(_nameController.text, _emailController.text);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text('SAVE CHANGES',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1)),
            ),
          ),
        ),
      ),
    );
  }
}
