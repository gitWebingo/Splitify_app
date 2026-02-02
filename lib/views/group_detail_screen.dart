import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/group_model.dart';
import '../models/expense_model.dart';
import '../controllers/data_controller.dart';
import 'add_expance_screen.dart';
import 'edit_group_screen.dart';
import '../models/user_model.dart'; // Needed for User comparison

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
    // Re-fetch group from controller to ensure updates (like name change) are reflected
    final controller = Provider.of<DataController>(context);
    // Find the group in the controller list using widget.group.id
    // If not found (deleted), pop? For now, we fallback to widget.group or handle gracefully.
    Group group;
    try {
      group = controller.groups.firstWhere((g) => g.id == widget.group.id);
    } catch (e) {
      // Group might be deleted or not found.
      group = widget.group;
    }

    final currentUser = controller.currentUser;

    // Calculate stats
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(color: AppColors.textPrimary),
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGroupScreen(group: group)),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(group.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditGroupScreen(group: group)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceCard(context, balance),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSummaryCard(context, 'You Paid',
                        '₹${youPaid.toStringAsFixed(2)}', AppColors.card),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                        context,
                        'Total',
                        '₹${totalGroupSpend.toStringAsFixed(2)}',
                        AppColors.card),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Members',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                _buildMembersList(group),
                const SizedBox(height: 32),
                _buildTabs(),
                const SizedBox(height: 16),
                _selectedTab == 0
                    ? _buildExpensesList(context, group)
                    : _buildBalancesList(context, group, currentUser),
                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildAddCostsButton(context, group),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    bool isOwed = balance >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isOwed ? AppColors.accent : AppColors.owe,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isOwed ? "You are owed" : "You owe",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Text('₹${balance.abs().toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, String title, String amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(amount,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(Group group) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: group.members.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final member = group.members[index];
          return CircleAvatar(
            backgroundColor: AppColors.surface,
            backgroundImage: member.profilePic != null
                ? NetworkImage(member.profilePic!)
                : null,
            child: member.profilePic == null
                ? Text(member.name[0],
                    style: const TextStyle(color: AppColors.textPrimary))
                : null,
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem('Expenses', 0),
          _buildTabItem('Balances', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context, Group group) {
    if (group.expenses.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("No expenses yet",
                  style: TextStyle(color: Colors.grey))));
    }
    // Sort expenses by date descending
    final sortedExpenses = List.from(group.expenses);
    sortedExpenses.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: sortedExpenses
          .map((expense) => _buildExpenseItem(context, expense as Expense))
          .toList(),
    );
  }

  Widget _buildBalancesList(
      BuildContext context, Group group, User currentUser) {
    // Logic for calculating pair-wise balances within this group
    // This is complex. We simplify: For each member, we show net balance relative to currentUser.
    // Or we show graph. The original design usually lists pair debts.
    // But let's stick to "My relationship with everyone in this group".

    final members = group.members.where((m) => m.id != currentUser.id).toList();

    if (members.isEmpty) {
      return const Center(child: Text("No other members"));
    }

    return Column(
      children: members.map((member) {
        double netBalanceRaw = 0.0;

        for (var expense in group.expenses) {
          // I paid, member involved
          if (expense.payer.id == currentUser.id &&
              expense.splitBetween.contains(member.id)) {
            netBalanceRaw += (expense.amount / expense.splitBetween.length);
          }
          // Member paid, I involved
          if (expense.payer.id == member.id &&
              expense.splitBetween.contains(currentUser.id)) {
            netBalanceRaw -= (expense.amount / expense.splitBetween.length);
          }
        }

        if (netBalanceRaw.abs() < 0.01)
          return const SizedBox.shrink(); // Settled

        bool isOwe = netBalanceRaw < 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: member.profilePic != null
                    ? NetworkImage(member.profilePic!)
                    : null,
                child: member.profilePic == null ? Text(member.name[0]) : null,
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(member.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text(isOwe ? "You owe" : "Owes you",
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ]),
              const Spacer(),
              Text("₹${netBalanceRaw.abs().toStringAsFixed(2)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isOwe ? AppColors.owe : AppColors.owed)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpenseItem(BuildContext context, Expense expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surface,
              child: Text(expense.payer.name[0],
                  style: const TextStyle(color: AppColors.textPrimary))),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text("${expense.payer.name} paid",
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          Text('₹${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildAddCostsButton(BuildContext context, Group group) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(group: group)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Add expense',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
