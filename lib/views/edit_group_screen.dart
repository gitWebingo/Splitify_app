import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Edit group',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.owe),
              onPressed: () {
                Provider.of<DataController>(context, listen: false)
                    .deleteGroup(widget.group.id);
                Navigator.pop(context); // Pop edit screen
                Navigator.pop(
                    context); // Pop GroupDetailScreen to go back to Home
              }),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Group name',
                    style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    fillColor: AppColors.card,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 32),
                const Text('Members',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                _buildMemberList(),
                const SizedBox(height: 24),
                _buildInviteButton(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return Column(
      children:
          _selectedMembers.map((member) => _buildMemberTile(member)).toList(),
    );
  }

  Widget _buildMemberTile(User member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
                  : NetworkImage('https://i.pravatar.cc/150?u=${member.name}')),
          const SizedBox(width: 12),
          Text(member.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: AppColors.textDisabled),
            onPressed: () {
              setState(() {
                _selectedMembers.remove(member);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInviteButton() {
    return InkWell(
      onTap: () {
        // Show friends list to add more
        _showAddMembersSheet();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ios_share, size: 20, color: AppColors.accent),
            const SizedBox(width: 12),
            const Text('Invite a friend',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  void _showAddMembersSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer<DataController>(
              builder: (context, controller, child) {
            final availableFriends = controller.friends
                .where((f) => !_selectedMembers.contains(f))
                .toList();
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Add Members",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                        itemCount: availableFriends.length,
                        itemBuilder: (context, index) {
                          final friend = availableFriends[index];
                          return ListTile(
                            title: Text(friend.name),
                            trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _selectedMembers.add(friend);
                                  });
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

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Provider.of<DataController>(context, listen: false).updateGroup(
                    widget.group.id, _nameController.text, _selectedMembers);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Save',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
