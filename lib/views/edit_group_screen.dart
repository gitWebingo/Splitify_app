import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../controllers/data_controller.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;
  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  late TextEditingController _nameController;
  late List<User> _selectedMembers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _selectedMembers = List.from(widget.group.members);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Edit Group',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              onPressed: () => _confirmDelete(context)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('GROUP NAME'),
                const SizedBox(height: 12),
                _buildNameField(),
                const SizedBox(height: 32),
                _buildSectionLabel('MEMBERS'),
                const SizedBox(height: 16),
                _buildMemberList(),
                const SizedBox(height: 24),
                _buildInviteButton(),
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildSaveAction(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text,
        style: GoogleFonts.plusJakartaSans(
            color: AppColors.textDisabled,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5));
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _nameController,
        style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          hintText: 'Enter group name',
          hintStyle: TextStyle(color: AppColors.textDisabled.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedMembers.length,
      itemBuilder: (context, index) {
        final member = _selectedMembers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: member.profilePic != null
                      ? ClipOval(
                          child: Image.network(member.profilePic!,
                              fit: BoxFit.cover))
                      : Text(member.name[0],
                          style: GoogleFonts.outfit(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 14),
              Text(member.name,
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 15)),
              const Spacer(),
              if (member.id !=
                  Provider.of<DataController>(context, listen: false)
                      .currentUser
                      .id)
                IconButton(
                  icon: Icon(Icons.remove_circle_outline_rounded,
                      color: AppColors.error.withOpacity(0.5), size: 22),
                  onPressed: () {
                    setState(() {
                      _selectedMembers.remove(member);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteButton() {
    return InkWell(
      onTap: _showAddMembersSheet,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mainColor.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_rounded,
                size: 20, color: AppColors.mainColor),
            const SizedBox(width: 12),
            Text('Add More Members',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainColor,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showAddMembersSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) {
          return Consumer<DataController>(
              builder: (context, controller, child) {
            final availableFriends = controller.friends
                .where((f) => !_selectedMembers.any((m) => m.id == f.id))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Members",
                      style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 20),
                  if (availableFriends.isEmpty)
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text("No more friends to add",
                          style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textDisabled)),
                    ))
                  else
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: availableFriends.length,
                          itemBuilder: (context, index) {
                            final friend = availableFriends[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.surface,
                                child: Text(friend.name[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              title: Text(friend.name,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700)),
                              subtitle: Text(friend.email,
                                  style: const TextStyle(fontSize: 12)),
                              trailing: IconButton(
                                  icon: const Icon(Icons.add_circle_rounded,
                                      color: AppColors.mainColor),
                                  onPressed: () {
                                    setState(
                                        () => _selectedMembers.add(friend));
                                    Navigator.pop(context);
                                  }),
                            );
                          }),
                    )
                ],
              ),
            );
          });
        });
  }

  Widget _buildSaveAction() {
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
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              Provider.of<DataController>(context, listen: false).updateGroup(
                  widget.group.id, _nameController.text, _selectedMembers);
              Navigator.pop(context);
            }
          },
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
              child: Text('SAVE CHANGES',
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

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text("Delete Group?",
            style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        content: const Text(
            "This action cannot be undone. All expenses in this group will be deleted."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL")),
          TextButton(
              onPressed: () {
                Provider.of<DataController>(context, listen: false)
                    .deleteGroup(widget.group.id);
                Navigator.pop(context); // Dialog
                Navigator.pop(context); // Edit Screen
                Navigator.pop(context); // Detail Screen
              },
              child: const Text("DELETE",
                  style: TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
