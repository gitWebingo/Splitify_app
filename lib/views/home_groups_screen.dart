import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/group_model.dart';
import 'group_detail_screen.dart';
import 'create_group_screen.dart';

class HomeGroupsScreen extends StatelessWidget {
  const HomeGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataController>(builder: (context, dataController, child) {
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
                  children: [
                    // Background with Abstract Shapes
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    Positioned(
                      top: -100,
                      right: -100,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Daily Overview',
                                        style: GoogleFonts.plusJakartaSans(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1)),
                                    const SizedBox(height: 6),
                                    Text(
                                        'Hello, ${dataController.currentUser.name.split(' ')[0]}!',
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1)),
                                  ],
                                ),
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Colors.white,
                                        size: 26),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _buildQuickStats(dataController),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tracking Groups',
                                style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.8)),
                            const SizedBox(height: 4),
                            Text(
                                '${dataController.groups.length} active groups',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.textDisabled,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Material(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateGroupScreen())),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_circle_outline_rounded,
                                      color: AppColors.mainColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text('NEW GROUP',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: AppColors.mainColor,
                                          letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    if (dataController.groups.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataController.groups.length,
                        itemBuilder: (context, index) {
                          return _buildElegantGroupCard(
                              context, dataController.groups[index]);
                        },
                      ),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuickStats(DataController controller) {
    double owe = controller.getTotalYouOwe();
    double owed = controller.getTotalOwedToYou();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Row(
          children: [
            Expanded(child: _buildStatTile('YOU OWE', owe, isNegative: true)),
            Container(
                width: 1.5, height: 50, color: Colors.white.withOpacity(0.1)),
            Expanded(
                child: _buildStatTile('OWED TO YOU', owed, isNegative: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, double amount,
      {required bool isNegative}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
          const SizedBox(height: 8),
          FittedBox(
            child: Text('₹${amount.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantGroupCard(BuildContext context, Group group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupDetailScreen(group: group))),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.mainColor, // Solid purple from screenshot
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(_getGroupIcon(group.type),
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4)),
                    const SizedBox(height: 4),
                    Text(group.memberNames,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textDisabled,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 24, color: Color(0xFFD1C4D1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.group_add_outlined,
                size: 48, color: AppColors.mainColor),
          ),
          const SizedBox(height: 24),
          Text("No Groups Found",
              style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
                "Create a group to start splitting expenses with friends.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textDisabled,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  IconData _getGroupIcon(String type) {
    switch (type) {
      case 'Home':
        return Icons.home_rounded;
      case 'Trip':
        return Icons.flight_takeoff_rounded;
      case 'Couple':
        return Icons.favorite_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
