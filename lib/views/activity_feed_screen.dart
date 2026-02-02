import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/group_model.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DataController>(builder: (context, controller, child) {
        // Get all expenses and group creations (simplified to just expenses and groups logic if possible,
        // but for now let's just list expenses as activity items)
        List<ActivityItem> activities = [];

        for (var group in controller.groups) {
          // Add Group Created event (simulated based on first expense or just skip for now as we don't have createdDate in Group)
          // We'll focus on expenses
          for (var expense in group.expenses) {
            activities.add(ActivityItem(
              type: 'Expense',
              title: 'Expense Added',
              subtitle:
                  '${expense.payer.name} added "${expense.description}" in "${group.name}"',
              date: expense.date,
              amount: expense.amount,
              icon: Icons.receipt_long_rounded,
              gradient: AppColors.primaryGradient,
            ));
          }
        }

        activities.sort((a, b) => b.date.compareTo(a.date));

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Activity',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            activities.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                        child: Text("No activity yet",
                            style: TextStyle(color: Colors.grey))))
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildTimeline(activities),
                      ),
                    ),
                  ),
          ],
        );
      }),
    );
  }

  List<Widget> _buildTimeline(List<ActivityItem> activities) {
    List<Widget> widgets = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    List<ActivityItem> todayItems = [];
    List<ActivityItem> yesterdayItems = [];
    List<ActivityItem> olderItems = [];

    for (var item in activities) {
      if (item.date.isAfter(today)) {
        todayItems.add(item);
      } else if (item.date.isAfter(yesterday)) {
        yesterdayItems.add(item);
      } else {
        olderItems.add(item);
      }
    }

    if (todayItems.isNotEmpty) {
      widgets.add(_buildTimelineSection(
          'Today',
          todayItems
              .map((e) =>
                  _buildActivityCard(e, DateFormat('h:mm a').format(e.date)))
              .toList()));
      widgets.add(const SizedBox(height: 24));
    }
    if (yesterdayItems.isNotEmpty) {
      widgets.add(_buildTimelineSection(
          'Yesterday',
          yesterdayItems
              .map((e) =>
                  _buildActivityCard(e, DateFormat('h:mm a').format(e.date)))
              .toList()));
      widgets.add(const SizedBox(height: 24));
    }
    if (olderItems.isNotEmpty) {
      widgets.add(_buildTimelineSection(
          'Older',
          olderItems
              .map((e) =>
                  _buildActivityCard(e, DateFormat('MMM d').format(e.date)))
              .toList()));
    }
    return widgets;
  }

  Widget _buildTimelineSection(String title, List<Widget> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1)),
        ),
        ...activities,
      ],
    );
  }

  Widget _buildActivityCard(ActivityItem item, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              gradient: item.gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Icon(item.icon, color: Colors.white, size: 24),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(time,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textDisabled)),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String type;
  final String title;
  final String subtitle;
  final DateTime date;
  final double amount;
  final IconData icon;
  final LinearGradient gradient;

  ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.icon,
    required this.gradient,
  });
}
