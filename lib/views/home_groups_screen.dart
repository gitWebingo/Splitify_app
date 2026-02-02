import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Consumer<DataController>(builder: (context, dataController, child) {
        return CustomScrollView(
          slivers: [
            // Unique App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          const Text('Welcome back,',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(dataController.currentUser.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _buildQuickStats(dataController),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: const Icon(Icons.search_rounded), onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {}),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Groups',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateGroupScreen()));
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text('New'),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryStart),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (dataController.groups.isEmpty)
                      const Center(
                          child: Text("No groups yet",
                              style: TextStyle(color: Colors.grey)))
                    else
                      ...dataController.groups.map((group) => _buildGroupCard(
                            context,
                            group,
                          )),
                    const SizedBox(height: 100),
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

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('You owe',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text('₹${owe.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Owed to you',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text('₹${owed.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard(BuildContext context, Group group) {
    IconData icon;
    LinearGradient gradient;

    switch (group.type) {
      case 'Home':
        icon = Icons.home_rounded;
        gradient = AppColors.primaryGradient;
        break;
      case 'Trip':
        icon = Icons.flight_rounded;
        gradient = AppColors.accentGradient;
        break;
      case 'Couple':
        icon = Icons.favorite_rounded;
        gradient = AppColors.owedGradient;
        break;
      default:
        icon = Icons.group_rounded;
        gradient = AppColors.oweGradient;
    }

    // Logic to calculate if settled or amount (simplified for card view)
    // For now we just show generic message or "settled" if no expenses
    String subtitle = group.expenses.isEmpty
        ? 'No expenses'
        : '${group.expenses.length} expenses';
    bool isSettled = group.expenses.isEmpty;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupDetailScreen(group: group)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(group.memberNames,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 14,
                            color: !isSettled
                                ? AppColors.owe
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
