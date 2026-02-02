import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart'; // For creating expense object
import '../controllers/data_controller.dart';

class PayDebtScreen extends StatefulWidget {
  final User targetUser;
  final String?
      groupId; // Optional context, mostly for recording where it happened

  const PayDebtScreen({super.key, required this.targetUser, this.groupId});

  @override
  State<PayDebtScreen> createState() => _PayDebtScreenState();
}

class _PayDebtScreenState extends State<PayDebtScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    final controller = Provider.of<DataController>(context, listen: false);
    final currentUser = controller.currentUser;

    // Create a payment expense
    // Payer: Current User
    // Split: Target User (100%)
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: 'Payment to ${widget.targetUser.name}',
      amount: amount,
      date: DateTime.now(),
      payer: currentUser,
      splitBetween: [widget.targetUser.id],
    );

    // If we have a groupId, add to that group. If not, finding a common group or creating a "Non-group" expense is tricky in current model.
    // For now, let's assume valid groupId is passed or we default to first shared group (logic to be enhanced).
    // If no groupId passed, we just pick the first group they are both in for this prototype?
    // Or we require groupId.
    // To make it robust, let's try to find a group or use a fallback.
    String? effectiveGroupId = widget.groupId;

    if (effectiveGroupId == null) {
      // Try to find a group they share
      for (var g in controller.groups) {
        bool hasTarget = g.members.any((m) => m.id == widget.targetUser.id);
        // Current user is always in group by definition of controller.groups (if fetching my groups)
        if (hasTarget) {
          effectiveGroupId = g.id;
          break;
        }
      }
    }

    if (effectiveGroupId != null) {
      controller.addExpense(effectiveGroupId, expense);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment recorded!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error: No common group found to record payment')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<DataController>(context).currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Pay off the debt',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildFlowCard(currentUser, widget.targetUser),
                const SizedBox(height: 24),
                _buildAmountField(),
                const SizedBox(height: 12),
                const Text('It is possible to pay off a debt in part',
                    style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildFlowCard(User payer, User receiver) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildUserBox(payer),
          const Icon(Icons.arrow_forward_rounded,
              color: AppColors.textDisabled),
          _buildUserBox(receiver),
        ],
      ),
    );
  }

  Widget _buildUserBox(User user) {
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
            backgroundImage: user.profilePic != null
                ? NetworkImage(user.profilePic!)
                : NetworkImage('https://i.pravatar.cc/150?u=${user.name}')),
        const SizedBox(width: 8),
        Text(user.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(color: AppColors.textDisabled),
              ),
            ),
          ),
          const Text('INR',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Pay off the debt',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
