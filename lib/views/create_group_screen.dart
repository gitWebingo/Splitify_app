import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../controllers/data_controller.dart';
import '../models/user_model.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController = TextEditingController();
  String _selectedType = 'Trip';
  final List<String> _types = ['Trip', 'Home', 'Couple', 'Other'];
  List<User> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser =
          Provider.of<DataController>(context, listen: false).currentUser;
      if (!_selectedMembers.any((m) => m.id == currentUser.id)) {
        setState(() {
          _selectedMembers.add(currentUser);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                leading: const BackButton(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Create Group',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      )),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Center(
                      child: Icon(Icons.group_add_rounded,
                          size: 80, color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GROUP INFO Section with padding
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('GROUP INFO'),
                          const SizedBox(height: 12),
                          _buildNameInput(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // SELECT CATEGORY Section
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: _buildSectionTitle('SELECT CATEGORY'),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildTypeSelector(),
                    ),
                    const SizedBox(height: 30),

                    // INVITE FRIENDS Section with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('INVITE FRIENDS'),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildMembersSliverList(),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textDisabled,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _nameController,
        style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Enter group name...',
          hintStyle: TextStyle(color: AppColors.textDisabled.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.edit_note_rounded,
              color: AppColors.mainColor, size: 30),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Row(
        children: _types.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isSelected = type == _selectedType;
          IconData icon;

          switch (type) {
            case 'Trip':
              icon = Icons.flight_takeoff_rounded;
              break;
            case 'Home':
              icon = Icons.home_rounded;
              break;
            case 'Couple':
              icon = Icons.favorite_rounded;
              break;
            default:
              icon = Icons.grid_view_rounded;
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 5,
                right: index == _types.length - 1 ? 0 : 5,
              ),
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,
                          color: isSelected
                              ? Colors.white
                              : AppColors.mainColor.withOpacity(0.7),
                          size: 26),
                      const SizedBox(height: 6),
                      Text(type,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMembersSliverList() {
    return Consumer<DataController>(
      builder: (context, controller, child) {
        if (controller.friends.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Text("No friends available to add.",
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textDisabled,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final friend = controller.friends[index];
                final isSelected =
                    _selectedMembers.any((m) => m.id == friend.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedMembers
                              .removeWhere((m) => m.id == friend.id);
                        } else {
                          _selectedMembers.add(friend);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.mainColor.withOpacity(0.3)
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.mainColor
                                  : AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(friend.name[0],
                                  style: GoogleFonts.outfit(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.mainColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(friend.name,
                                    style: GoogleFonts.outfit(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 19)),
                                Text(friend.email,
                                    style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textDisabled,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.add_circle_outline_rounded,
                            color: isSelected
                                ? AppColors.mainColor
                                : AppColors.textDisabled.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: controller.friends.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction() {
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
          onPressed: _createGroup,
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
              child: Text('CREATE GROUP',
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

  void _createGroup() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a group name')));
      return;
    }

    final dataController = Provider.of<DataController>(context, listen: false);
    final currentUser = dataController.currentUser;
    if (!_selectedMembers.any((m) => m.id == currentUser.id)) {
      _selectedMembers.add(currentUser);
    }

    dataController.addGroup(
      _nameController.text,
      _selectedType,
      _selectedMembers,
    );
    Navigator.pop(context);
  }
}
