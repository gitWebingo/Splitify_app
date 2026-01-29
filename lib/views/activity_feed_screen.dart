import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineSection('Today', [
                    _buildActivityCard(
                        'Group Created',
                        'You created "Bachkunda"',
                        '1:58 PM',
                        Icons.group_add_rounded,
                        AppColors.primaryGradient),
                  ]),
                  const SizedBox(height: 24),
                  _buildTimelineSection('Yesterday', [
                    _buildActivityCard(
                        'Payment Made',
                        'You paid Manish \$106.25',
                        '1:38 PM',
                        Icons.payment_rounded,
                        AppColors.owedGradient),
                    _buildActivityCard(
                        'Expense Added',
                        'Manish added "Travel"',
                        '1:36 PM',
                        Icons.receipt_long_rounded,
                        AppColors.oweGradient),
                    _buildActivityCard(
                        'Settings Changed',
                        'Simplify debts enabled',
                        '1:34 PM',
                        Icons.settings_rounded,
                        AppColors.accentGradient),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildActivityCard(String title, String subtitle, String time,
      IconData icon, LinearGradient gradient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle,
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
