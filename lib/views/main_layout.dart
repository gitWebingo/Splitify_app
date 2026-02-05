import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_groups_screen.dart';
import 'friends_list_screen.dart';
import 'activity_feed_screen.dart';
import 'account_profile_screen.dart';
import '../core/app_colors.dart';
import 'create_group_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeGroupsScreen(),
    const FriendsListScreen(),
    const ActivityFeedScreen(),
    const AccountProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Groups'),
              _buildNavItem(1, Icons.people_rounded, 'Friends'),
              _buildNavItem(2, Icons.history_rounded, 'Activity'),
              _buildNavItem(3, Icons.account_circle_rounded, 'Account'),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex < 2 ? _buildPremiumFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.mainColor : AppColors.textDisabled,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color:
                    isSelected ? AppColors.mainColor : AppColors.textDisabled,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 0), // Moved downward
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateGroupScreen()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.mainColor, // Purple from screenshot
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, size: 24, color: Colors.white),
              const SizedBox(width: 8),
              Text('NEW GROUP',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
