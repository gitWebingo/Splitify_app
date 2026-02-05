import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../models/expence_model.dart';
import 'pay_debt_screen.dart';

class FriendDetailsScreen extends StatelessWidget {
  final User friend;

  const FriendDetailsScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataController>(builder: (context, controller, child) {
        final sharedData = _getSharedActivity(controller, friend);
        final double balance = sharedData['balance'];
        final List<Group> mutualGroups = sharedData['groups'];
        final List<Expense> sharedExpenses = sharedData['expenses'];

        return Stack(
          children: [
            // 1. BRANDED BACKGROUND LAYER
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 380,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Stack(
                  children: [
                    // Dynamic Abstract Depth
                    Positioned(
                      top: -100,
                      right: -80,
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: -40,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. SCROLLABLE CONTENT
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 0,
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // PROFILE HERO
                        _buildHeroProfile(friend),
                        const SizedBox(height: 48),

                        // FLOATING DASHBOARD BALANCE
                        _buildPremiumBalanceCard(balance),

                        const SizedBox(height: 40),

                        // STATS ROW (Glass Style)
                        _buildSummaryStats(sharedData),

                        const SizedBox(height: 48),

                        // CONTENT BODY
                        _buildSectionHeader(
                            'SHARED CIRCLES', '${mutualGroups.length} Groups'),
                        const SizedBox(height: 16),
                        if (mutualGroups.isEmpty)
                          _buildEmptyPlaceholder('No shared groups found')
                        else
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: mutualGroups.length,
                              itemBuilder: (context, index) =>
                                  _buildGroupCard(mutualGroups[index]),
                            ),
                          ),

                        const SizedBox(height: 40),

                        _buildSectionHeader('RECENT ACCOUNTS', 'History'),
                        const SizedBox(height: 16),
                        if (sharedExpenses.isEmpty)
                          _buildEmptyPlaceholder('No recent logs found')
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sharedExpenses.length,
                            itemBuilder: (context, index) =>
                                _buildTimelineItem(sharedExpenses[index]),
                          ),

                        const SizedBox(height: 160),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildPremiumActionDock(context),
      extendBody: true,
    );
  }

  // DATA LOGIC
  Map<String, dynamic> _getSharedActivity(
      DataController controller, User friend) {
    double balance = 0.0;
    double youPaid = 0.0;
    double theyPaid = 0.0;
    List<Group> mutualGroups = [];
    List<Expense> sharedExpenses = [];
    final currentUser = controller.currentUser;

    for (var group in controller.groups) {
      if (group.members.any((m) => m.id == friend.id)) mutualGroups.add(group);

      for (var expense in group.expenses) {
        bool involved = (expense.payer.id == currentUser.id &&
            expense.splitBetween.contains(friend.id)) ||
            (expense.payer.id == friend.id &&
                expense.splitBetween.contains(currentUser.id));

        if (involved) {
          sharedExpenses.add(expense);
          double share = expense.amount / expense.splitBetween.length;
          if (expense.payer.id == currentUser.id) {
            youPaid += expense.amount;
            balance += share;
          } else {
            theyPaid += expense.amount;
            balance -= share;
          }
        }
      }
    }
    sharedExpenses.sort((a, b) => b.date.compareTo(a.date));
    return {
      'balance': balance,
      'groups': mutualGroups,
      'expenses': sharedExpenses,
      'youPaid': youPaid,
      'theyPaid': theyPaid
    };
  }

  // WIDGETS
  Widget _buildHeroProfile(User friend) {
    return Column(
      children: [
        Hero(
          tag: 'friend_avatar_${friend.id}',
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
              Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: friend.profilePic != null
                    ? NetworkImage(friend.profilePic!)
                    : null,
                child: friend.profilePic == null
                    ? Text(friend.name[0].toUpperCase(),
                    style: GoogleFonts.outfit(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainColor))
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(friend.name,
            style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.6)),
        Text(friend.email.toLowerCase(),
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildPremiumBalanceCard(double balance) {
    bool isOwe = balance < 0;
    bool isSettled = balance.abs() < 0.01;
    Color color = isSettled
        ? AppColors.mainColor
        : (isOwe ? const Color(0xFFE53935) : const Color(0xFF43A047));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 40,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              isSettled ? "SETTLED" : (isOwe ? "OWES TO YOU" : "YOU OWE HIM"),
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "₹${balance.abs().toStringAsFixed(2)}",
            style: GoogleFonts.outfit(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -1.5),
          ),
          const SizedBox(height: 8),
          Text("NET GLOBAL BALANCE",
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDisabled,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(Map<String, dynamic> data) {
    return Row(
      children: [
        _buildStatTile('Paid by you', '₹${data['youPaid'].toStringAsFixed(0)}',
            const Color(0xFF6366F1)),
        const SizedBox(width: 16),
        _buildStatTile('Paid by him', '₹${data['theyPaid'].toStringAsFixed(0)}',
            const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color.withOpacity(0.7))),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textDisabled,
                letterSpacing: 1.5)),
        Text(action,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.mainColor,
                fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildGroupCard(Group group) {
    return Container(
      width: 156,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.hub_rounded,
                color: AppColors.mainColor, size: 20),
          ),
          const Spacer(),
          Text(group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Text(group.type,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Expense expense) {
    bool isPayer = expense.payer.id == friend.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16)),
            child: Icon(
                isPayer
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color:
                isPayer ? const Color(0xFFE53935) : const Color(0xFF43A047),
                size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description,
                    style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(DateFormat('MMM dd').format(expense.date),
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textDisabled,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text('₹${expense.amount.toStringAsFixed(0)}',
              style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String msg) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Text(msg,
            style: GoogleFonts.plusJakartaSans(
                color: AppColors.textDisabled,
                fontSize: 13,
                fontWeight: FontWeight.w600)));
  }

  Widget _buildPremiumActionDock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.mainColorDark,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
                color: AppColors.mainColorDark.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PayDebtScreen(targetUser: friend)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.mainColorDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),
                child: Text('SETTLE BILL',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.5)),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.notifications_active_rounded,
                    color: Colors.white, size: 22),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
