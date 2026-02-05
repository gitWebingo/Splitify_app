import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/group_model.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataController>(builder: (context, controller, child) {
        List<ActivityItem> activities = [];

        for (var group in controller.groups) {
          for (var expense in group.expenses) {
            activities.add(ActivityItem(
              type: 'Expense',
              title: 'New Expense',
              subtitle:
                  '${expense.payer.name} added "${expense.description}" in ${group.name}',
              date: expense.date,
              amount: expense.amount,
              icon: Icons.receipt_long_rounded,
              gradient: AppColors.primaryGradient,
            ));
          }
        }

        activities.sort((a, b) => b.date.compareTo(a.date));

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Activity Feed',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
              ),
            ),
            activities.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off_rounded,
                          size: 64,
                          color: AppColors.textDisabled.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text("No recent activity",
                          style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textDisabled,
                              fontWeight: FontWeight.w600)),
                    ],
                  )))
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
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
      widgets.add(_buildTimelineHeader('TODAY'));
      widgets.addAll(todayItems.map(
          (e) => _buildActivityCard(e, DateFormat('h:mm a').format(e.date))));
      widgets.add(const SizedBox(height: 15));
    }
    if (yesterdayItems.isNotEmpty) {
      widgets.add(_buildTimelineHeader('YESTERDAY'));
      widgets.addAll(yesterdayItems.map(
          (e) => _buildActivityCard(e, DateFormat('h:mm a').format(e.date))));
      widgets.add(const SizedBox(height: 15));
    }
    if (olderItems.isNotEmpty) {
      widgets.add(_buildTimelineHeader('OLDER'));
      widgets.addAll(olderItems.map(
          (e) => _buildActivityCard(e, DateFormat('MMM d').format(e.date))));
    }
    return widgets;
  }

  Widget _buildTimelineHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDisabled,
              letterSpacing: 2)),
    );
  }

  Widget _buildActivityCard(ActivityItem item, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: AppColors.mainColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title,
                        style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text(time,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textDisabled,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w500)),
                if (item.amount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('₹${item.amount.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainColor)),
                  ),
              ],
            ),
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
