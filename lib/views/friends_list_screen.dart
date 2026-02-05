import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/user_model.dart';
import 'friend_details_screen.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataController>(builder: (context, controller, child) {
        List<User> friends = controller.friends;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Background with Abstract Shapes
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    Positioned(
                      top: -80,
                      right: -80,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PEOPLE & CIRCLE',
                                        style: GoogleFonts.plusJakartaSans(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2)),
                                    const SizedBox(height: 8),
                                    Text('Friends List',
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1)),
                                  ],
                                ),
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.person_add_alt_1_rounded,
                                        color: Colors.white,
                                        size: 26),
                                    onPressed: () =>
                                        _showAddFriendDialog(context),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.people_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                      '${friends.length} active friends in your network',
                                      style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mutual Expenses',
                        style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.6)),
                    const SizedBox(height: 24),
                    if (friends.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          double balance =
                              _calculateBalanceWithFriend(controller, friend);
                          return _buildElegantFriendCard(
                              context, friend, balance);
                        },
                      ),
                    const SizedBox(height: 120),
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
        if (expense.payer.id == currentUser.id &&
            expense.splitBetween.contains(friend.id)) {
          balance += (expense.amount / expense.splitBetween.length);
        }
        if (expense.payer.id == friend.id &&
            expense.splitBetween.contains(currentUser.id)) {
          balance -= (expense.amount / expense.splitBetween.length);
        }
      }
    }
    return balance;
  }

  Widget _buildElegantFriendCard(
      BuildContext context, User friend, double balance) {
    bool isOwe = balance < 0;
    bool isSettled = balance.abs() < 0.01;
    String amountText =
        isSettled ? "Settled" : "₹${balance.abs().toStringAsFixed(0)}";
    String subtitle = isSettled
        ? "All settled up"
        : (isOwe ? "You owe them" : "They owe you");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FriendDetailsScreen(friend: friend)));
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: friend.profilePic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(friend.profilePic!,
                              fit: BoxFit.cover))
                      : Text(friend.name[0].toUpperCase(),
                          style: GoogleFonts.outfit(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 26)),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friend.name,
                        style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: isSettled
                                ? AppColors.textDisabled
                                : (isOwe
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF43A047)),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              if (!isSettled)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(amountText,
                        style: GoogleFonts.outfit(
                            color: isOwe
                                ? const Color(0xFFE53935)
                                : const Color(0xFF43A047),
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    const SizedBox(height: 2),
                    const Icon(Icons.chevron_right_rounded,
                        size: 26, color: Color(0xFFD1C4D1)),
                  ],
                )
              else
                const Icon(Icons.check_circle_outline_rounded,
                    color: Color(0xFF43A047), size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_search_rounded,
                size: 48, color: AppColors.mainColor),
          ),
          const SizedBox(height: 24),
          Text("Expand Your Circle",
              style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
                "Add friends to start splitting group bills effortlessly.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textDisabled,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text("Add New Friend",
                  style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text("Invite a friend to your circle by adding their details.",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: AppColors.textDisabled,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 32),
              _buildInputLabel("FRIEND'S NAME"),
              const SizedBox(height: 12),
              _buildTextField("Enter full name", Icons.person_outline_rounded,
                  nameController),
              const SizedBox(height: 24),
              _buildInputLabel("EMAIL ADDRESS"),
              const SizedBox(height: 12),
              _buildTextField(
                  "Enter email address", Icons.email_outlined, emailController),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Provider.of<DataController>(context, listen: false)
                          .addFriend(nameController.text, emailController.text);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Add Friend",
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary.withOpacity(0.5),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColors.textDisabled.withOpacity(0.4), fontSize: 15),
          prefixIcon: Icon(icon, color: AppColors.mainColor.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
