import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/expence_model.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../controllers/data_controller.dart';

class AddExpenseScreen extends StatefulWidget {
  final Group group;
  const AddExpenseScreen({super.key, required this.group});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  late User _selectedPayer;
  List<String> _splitBetweenIds = [];

  @override
  void initState() {
    super.initState();
    final currentUser =
        Provider.of<DataController>(context, listen: false).currentUser;
    if (widget.group.members.any((m) => m.id == currentUser.id)) {
      _selectedPayer = currentUser;
    } else {
      _selectedPayer = widget.group.members.first;
    }
    _splitBetweenIds = widget.group.members.map((e) => e.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: const BackButton(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Add Expense',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      )),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mainColor.withOpacity(0.1),
                          AppColors.background
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildSectionHeader('DETAILS'),
                      const SizedBox(height: 16),
                      _buildInputCard(
                        'Description',
                        'What was it for?',
                        _descriptionController,
                        Icons.description_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildInputCard(
                        'Amount',
                        '0.00',
                        _amountController,
                        Icons.currency_rupee_rounded,
                        isNumber: true,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionHeader('PAYMENT INFO'),
                      const SizedBox(height: 16),
                      _buildPayerSelector(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('SPLIT BETWEEN'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              _buildMembersSelectionList(),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary.withOpacity(0.6),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildInputCard(String label, String hint,
      TextEditingController controller, IconData icon,
      {bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mainColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                TextField(
                  controller: controller,
                  keyboardType: isNumber
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.2)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayerSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                size: 20, color: AppColors.mainColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paid by',
                    style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                DropdownButton<User>(
                  value: _selectedPayer,
                  dropdownColor: AppColors.card,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary.withOpacity(0.5)),
                  items: widget.group.members.map((User member) {
                    return DropdownMenuItem<User>(
                      value: member,
                      child: Text(member.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (User? newValue) {
                    setState(() {
                      _selectedPayer = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSelectionList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final member = widget.group.members[index];
            final isSelected = _splitBetweenIds.contains(member.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_splitBetweenIds.length > 1) {
                        _splitBetweenIds.remove(member.id);
                      }
                    } else {
                      _splitBetweenIds.add(member.id);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainColor.withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.mainColor.withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.mainColor
                              : AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(member.name[0],
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.mainColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(member.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline_rounded,
                        color: isSelected
                            ? AppColors.mainColor
                            : AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: widget.group.members.length,
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background.withOpacity(0.0),
              AppColors.background
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ElevatedButton(
          onPressed: _saveExpense,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            shadowColor: AppColors.mainColor.withOpacity(0.5),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: const Text('Add This Expense',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  void _saveExpense() {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text);

    if (description.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter valid description and amount')),
      );
      return;
    }

    final expense = Expense(
      id: DateTime.now().toIso8601String(),
      description: description,
      amount: amount,
      date: DateTime.now(),
      payer: _selectedPayer,
      splitBetween: _splitBetweenIds,
    );

    Provider.of<DataController>(context, listen: false)
        .addExpense(widget.group.id, expense);
    Navigator.pop(context);
  }
}
