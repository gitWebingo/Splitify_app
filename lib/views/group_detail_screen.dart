import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'edit_group_screen.dart';
import 'pay_debt_screen.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Icon(Icons.notifications_none_rounded),
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditGroupScreen()),
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
              children: const [
                Text('Group 1',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
            ),
            onPressed: () {},
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
                _buildImOwedCard(context),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSummaryCard(
                        context, 'My costs', '-270,00 €', AppColors.card),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                        context, 'Total costs', '270,00 €', AppColors.card),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Members',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                _buildMembersList(),
                const SizedBox(height: 32),
                _buildTabs(),
                const SizedBox(height: 16),
                _buildDebtsList(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildAddCostsButton(),
        ],
      ),
    );
  }

  Widget _buildImOwedCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("I'm owed",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87)),
          SizedBox(height: 8),
          Text("225,00 €",
              style: TextStyle(
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

  Widget _buildMembersList() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 5) {
            return CircleAvatar(
              backgroundColor: AppColors.surface,
              child:
                  Text('R', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$index'),
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
          _buildTabItem('Debts', true),
          _buildTabItem('Balance', false),
          _buildTabItem('Transactions', false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive) {
    return Expanded(
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
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDebtsList(BuildContext context) {
    return Column(
      children: [
        _buildDebtItem(context, 'Karina', 'Anastasia', '45,00€'),
        _buildDebtItem(context, 'Tania', 'Anastasia', '45,00€'),
        _buildDebtItem(context, 'Roma', 'Anastasia', '45,00€'),
      ],
    );
  }

  Widget _buildDebtItem(
      BuildContext context, String from, String to, String amount) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PayDebtScreen()),
        );
      },
      child: Container(
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
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?u=$from')),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded,
                size: 16, color: AppColors.textDisabled),
            const SizedBox(width: 8),
            CircleAvatar(
                radius: 18,
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?u=$to')),
            const SizedBox(width: 12),
            Text(from,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const Spacer(),
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCostsButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Add costs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
