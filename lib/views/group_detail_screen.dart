import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/expence_model.dart';
import '../models/group_model.dart';
import '../controllers/data_controller.dart';
import 'add_expance_screen.dart';
import 'edit_group_screen.dart';
import '../models/user_model.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int _selectedTab = 0; // 0 for Expenses, 1 for Balances

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DataController>(context);
    Group group;
    try {
      group = controller.groups.firstWhere((g) => g.id == widget.group.id);
    } catch (e) {
      group = widget.group;
    }

    final currentUser = controller.currentUser;

    double totalGroupSpend =
        group.expenses.fold(0.0, (sum, e) => sum + e.amount);
    double youPaid = group.expenses
        .where((e) => e.payer.id == currentUser.id)
        .fold(0.0, (sum, e) => sum + e.amount);
    double yourShare = group.expenses
        .where((e) => e.splitBetween.contains(currentUser.id))
        .fold(0.0, (sum, e) => sum + (e.amount / e.splitBetween.length));

    double balance = youPaid - yourShare;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. PURPLE HEADER
              SliverAppBar(
                expandedHeight: 220,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.mainColorDark,
                elevation: 0,
                leading: const BackButton(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditGroupScreen(group: group)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    decoration: const BoxDecoration(
                      color: AppColors.mainColorDark,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(group.name,
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1)),
                        const SizedBox(height: 12),
                        _buildInterlockingRings(),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. MAIN BALANCE CARD
                      _buildBalanceCard(balance),

                      const SizedBox(height: 16),

                      // 3. SUMMARY CARDS
                      Row(
                        children: [
                          _buildMiniSummaryCard(
                              'You Paid',
                              '₹${youPaid.toStringAsFixed(2)}',
                              const Color(
                                  0xFFF3E5F5), // Light purple background
                              AppColors.mainColorDark),
                          const SizedBox(width: 12),
                          _buildMiniSummaryCard(
                              'Total Spent',
                              '₹${totalGroupSpend.toStringAsFixed(2)}',
                              Colors.white,
                              AppColors.mainColorDark,
                              hasBorder: true),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // 4. TABS
                      _buildTabs(),

                      const SizedBox(height: 24),

                      // 5. LIST CONTENT
                      if (_selectedTab == 0)
                        _buildExpensesList(context, group)
                      else
                        _buildBalancesList(context, group, currentUser),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 6. STICKY ADD EXPENSE BUTTON
          _buildAddExpenseButton(context, group),
        ],
      ),
    );
  }

  Widget _buildInterlockingRings() {
    return SizedBox(
      height: 38,
      width: 100, // Explicit width for the stack
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            left: index * 26.0, // Overlap by 12 pixels (38 - 12 = 26)
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                color: Colors.transparent,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    bool isOwed = balance >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.mainColorDark, // Solid deep purple
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isOwed ? "You are owed" : "You owe",
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 12),
          Text('₹${balance.abs().toStringAsFixed(2)}',
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                  color: Colors.white,
                  letterSpacing: -1)),
        ],
      ),
    );
  }

  Widget _buildMiniSummaryCard(
      String title, String amount, Color bgColor, Color textColor,
      {bool hasBorder = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: hasBorder
              ? Border.all(color: AppColors.border, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.5))),
            const SizedBox(height: 6),
            Text(amount,
                style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTabItem('Expenses', 0),
        const SizedBox(width: 40),
        _buildTabItem('Balances', 1),
      ],
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isActive
                      ? AppColors.mainColorDark
                      : AppColors.textDisabled,
                  letterSpacing: -0.5)),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mainColorDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context, Group group) {
    if (group.expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text("No expenses yet",
              style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textDisabled, fontWeight: FontWeight.w600)),
        ),
      );
    }
    final sortedExpenses = List.from(group.expenses);
    sortedExpenses.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: sortedExpenses
          .map((expense) => _buildExpenseItem(context, expense as Expense))
          .toList(),
    );
  }

  Widget _buildExpenseItem(BuildContext context, Expense expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5), // Light purple avatar background
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(expense.description[0].toUpperCase(),
                  style: GoogleFonts.outfit(
                      color: AppColors.mainColorDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: AppColors.mainColorDark)),
                Text("Paid by ${expense.payer.name.split(' ')[0]}",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textDisabled,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text('₹${expense.amount.toStringAsFixed(2)}',
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.mainColorDark,
                  letterSpacing: -0.5)),
        ],
      ),
    );
  }

  Widget _buildBalancesList(
      BuildContext context, Group group, User currentUser) {
    final members = group.members.where((m) => m.id != currentUser.id).toList();

    if (members.isEmpty) {
      return Center(
          child: Text("No other members in this group",
              style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textDisabled, fontWeight: FontWeight.w600)));
    }

    return Column(
      children: members.map((member) {
        double netBalanceRaw = 0.0;

        for (var expense in group.expenses) {
          if (expense.payer.id == currentUser.id &&
              expense.splitBetween.contains(member.id)) {
            netBalanceRaw += (expense.amount / expense.splitBetween.length);
          }
          if (expense.payer.id == member.id &&
              expense.splitBetween.contains(currentUser.id)) {
            netBalanceRaw -= (expense.amount / expense.splitBetween.length);
          }
        }

        if (netBalanceRaw.abs() < 0.01) return const SizedBox.shrink();

        bool isOwe = netBalanceRaw < 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFF3E5F5),
                backgroundImage: member.profilePic != null
                    ? NetworkImage(member.profilePic!)
                    : null,
                child: member.profilePic == null
                    ? Text(member.name[0],
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            color: AppColors.mainColorDark))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name,
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: AppColors.mainColorDark)),
                      Text(isOwe ? "You owe" : "Owes you",
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isOwe
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
              Text("₹${netBalanceRaw.abs().toStringAsFixed(2)}",
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: isOwe
                          ? const Color(0xFFE53935)
                          : const Color(0xFF2E7D32),
                      letterSpacing: -0.5)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddExpenseButton(BuildContext context, Group group) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.9),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.mainColorDark,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainColorDark.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(group: group)),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Text('ADD EXPENSE',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
