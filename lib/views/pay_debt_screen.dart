import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/expence_model.dart';
import '../models/user_model.dart';
import '../controllers/data_controller.dart';

class PayDebtScreen extends StatefulWidget {
  final User targetUser;
  final String? groupId;

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

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: 'Payment to ${widget.targetUser.name}',
      amount: amount,
      date: DateTime.now(),
      payer: currentUser,
      splitBetween: [widget.targetUser.id],
    );

    String? effectiveGroupId = widget.groupId;
    if (effectiveGroupId == null) {
      for (var g in controller.groups) {
        if (g.members.any((m) => m.id == widget.targetUser.id)) {
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Settle Up',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              _buildFlowBar(currentUser, widget.targetUser),
              const SizedBox(height: 32),
              _buildAmountInput(),
              const SizedBox(height: 16),
              Text(
                  'Payments are recorded as expenses between you and ${widget.targetUser.name}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textDisabled,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.5)),
              const SizedBox(height: 100), // Space for floating button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPayAction(),
    );
  }

  Widget _buildFlowBar(User payer, User receiver) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.mainColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildUserAvatar(payer),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward_rounded,
                color: AppColors.mainColor, size: 20),
          ),
          _buildUserAvatar(receiver),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(User user) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage:
                user.profilePic != null ? NetworkImage(user.profilePic!) : null,
            child: user.profilePic == null
                ? Text(user.name[0],
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainColor,
                        fontSize: 22))
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(user.name,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 13)),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text('₹',
              style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.mainColor)),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle:
                    TextStyle(color: AppColors.textDisabled.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.0), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ElevatedButton(
          onPressed: _handlePayment,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text('RECORD PAYMENT',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1)),
            ),
          ),
        ),
      ),
    );
  }
}
