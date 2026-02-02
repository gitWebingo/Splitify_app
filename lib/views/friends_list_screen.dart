import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/user_model.dart';
import 'pay_debt_screen.dart'; // Import PayDebtScreen

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DataController>(builder: (context, controller, child) {
        List<User> friends = controller.friends;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              floating: false, // Make it floating if list is long
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Friends',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.people_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text('${friends.length} Friends',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: const Icon(Icons.person_add_rounded),
                    onPressed: () {}),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (friends.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                            child: Text("No friends added yet",
                                style: TextStyle(color: Colors.grey))),
                      ),
                    ...friends.map((friend) {
                      double balance =
                          _calculateBalanceWithFriend(controller, friend);
                      return _buildFriendCard(context, friend, balance);
                    }).toList(),
                    const SizedBox(height: 20),
                    _buildAddFriendCard(context),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  double _calculateBalanceWithFriend(DataController controller, User friend) {
    double balance = 0.0;
    final currentUser = controller.currentUser;
    for (var group in controller.groups) {
      for (var expense in group.expenses) {
        // If I paid, and friend is in split
        if (expense.payer.id == currentUser.id &&
            expense.splitBetween.contains(friend.id)) {
          balance += (expense.amount / expense.splitBetween.length);
        }
        // If Friend paid, and I am in split
        if (expense.payer.id == friend.id &&
            expense.splitBetween.contains(currentUser.id)) {
          balance -= (expense.amount / expense.splitBetween.length);
        }
      }
    }
    return balance;
  }

  Widget _buildFriendCard(BuildContext context, User friend, double balance) {
    bool isOwe = balance < 0; // I owe them
    bool isSettled = balance.abs() < 0.01;
    String amountText =
        isSettled ? "Settled" : "₹${balance.abs().toStringAsFixed(2)}";
    Color amountColor = isSettled ? AppColors.textSecondary : Colors.white;
    LinearGradient? amountGradient = isSettled
        ? null
        : (isOwe ? AppColors.oweGradient : AppColors.owedGradient);
    String subtitle =
        isSettled ? "All settled up" : (isOwe ? "You owe" : "Owes you");

    return InkWell(
      onTap: () {
        // Navigate to PayDebtScreen if there is a balance, or just generic friend details
        if (!isSettled && isOwe) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PayDebtScreen(targetUser: friend)));
        } else if (!isSettled && !isOwe) {
          // Maybe remind them? For now, just PayDebt can act as settle up reverse?
          // Or typically "Settle Up" is bi-directional "Record a payment".
          // Let's use PayDebtScreen for now, assuming logic can handle "receiving" if we adapted it,
          // but current PayDebt is "I pay".
          // So if I am owed, I shouldn't see "Pay off debt".
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Remind feature coming soon!')));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple
                  ], // Simple placeholder gradient for avatar
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: friend.profilePic != null
                    ? NetworkImage(friend.profilePic!)
                    : null,
                child: friend.profilePic == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (!isSettled)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: amountGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(amountText,
                    style: TextStyle(
                        color: amountColor, fontWeight: FontWeight.bold)),
              ),
            if (isSettled)
              const Icon(Icons.check_circle_outline_rounded,
                  color: AppColors.settled),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFriendCard(BuildContext context) {
    return InkWell(
      onTap: () {
        _showAddFriendDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_add_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Add New Friend',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.card,
            title: const Text("Add Friend",
                style: TextStyle(color: AppColors.textPrimary)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: AppColors.textDisabled)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: AppColors.textDisabled)),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Provider.of<DataController>(context, listen: false)
                          .addFriend(nameController.text, emailController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }
}
