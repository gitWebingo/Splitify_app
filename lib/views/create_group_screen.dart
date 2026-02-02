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
    // Use addPostFrameCallback to handle Provider context safely if needed,
    // but for simple non-listening access, we can do it here if controller is ready.
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
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: const BackButton(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('New Group',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: -0.5,
                      )),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mainColor.withOpacity(0.15),
                          AppColors.background
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.group_add_rounded,
                            size: 100, color: AppColors.mainColor),
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
                      _buildSectionTitle('GROUP DETAILS'),
                      const SizedBox(height: 16),
                      _buildNameInput(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('CATEGORY'),
                      const SizedBox(height: 16),
                      _buildTypeSelector(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('ADD MEMBERS'),
                      const SizedBox(height: 16),
                    ],
                  ),
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
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary.withOpacity(0.6),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Group Name',
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.3)),
          prefixIcon:
              const Icon(Icons.edit_note_rounded, color: AppColors.mainColor),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _types.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final type = _types[index];
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

          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 95,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mainColor : AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.mainColor
                      : Colors.white.withOpacity(0.05),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.mainColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.background.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(type,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMembersSliverList() {
    return Consumer<DataController>(
      builder: (context, controller, child) {
        if (controller.friends.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: Text("No friends yet. Add some first!",
                    style: TextStyle(color: Colors.grey)),
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
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient:
                                  isSelected ? AppColors.primaryGradient : null,
                              color: isSelected ? null : AppColors.background,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(friend.name[0],
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(friend.name,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(friend.email,
                                    style: TextStyle(
                                        color: AppColors.textSecondary
                                            .withOpacity(0.6),
                                        fontSize: 12)),
                              ],
                            ),
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
            colors: [
              AppColors.background.withOpacity(0.0),
              AppColors.background
            ],
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
              child: const Text('Create New Group',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5)),
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
