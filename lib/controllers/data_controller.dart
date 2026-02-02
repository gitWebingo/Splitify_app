import 'package:flutter/material.dart';
import '../models/expence_model.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';

class DataController extends ChangeNotifier {
  User currentUser = User(
    id: 'u1',
    name: 'Nipa',
    email: 'nipa@example.com',
  );

  List<User> friends = [
    User(id: 'u2', name: 'Rahul', email: 'rahul@example.com'),
    User(id: 'u3', name: 'Simran', email: 'simran@example.com'),
    User(id: 'u4', name: 'Amit', email: 'amit@example.com'),
    User(id: 'u5', name: 'Priya', email: 'priya@example.com'),
  ];

  void updateUser(String name, String email) {
    currentUser = User(
        id: currentUser.id,
        name: name,
        email: email,
        profilePic: currentUser.profilePic);
    notifyListeners();
  }

  void addFriend(String name, String email) {
    friends.add(User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email.isEmpty ? "no-email@example.com" : email));
    notifyListeners();
  }

  List<Group> groups = [];

  DataController() {
    _populateDummyData();
  }

  void _populateDummyData() {
    groups = [
      Group(
        id: 'g1',
        name: 'Bachkunda',
        type: 'Trip',
        members: [currentUser, friends[0], friends[1], friends[2]],
        expenses: [],
      ),
      Group(
        id: 'g2',
        name: 'House',
        type: 'Home',
        members: [currentUser, friends[3]],
        expenses: [],
      ),
    ];

    // Add some dummy expenses
    addExpense(
        'g1',
        Expense(
          id: 'e1',
          description: 'Dinner',
          amount: 1200,
          date: DateTime.now().subtract(const Duration(days: 2)),
          payer: currentUser,
          splitBetween: ['u1', 'u2', 'u3', 'u4'],
        ));
    addExpense(
        'g1',
        Expense(
          id: 'e2',
          description: 'Cab',
          amount: 500,
          date: DateTime.now().subtract(const Duration(days: 1)),
          payer: friends[0], // Rahul paid
          splitBetween: ['u1', 'u2', 'u3', 'u4'],
        ));
  }

  void addGroup(String name, String type, List<User> members) {
    final newGroup = Group(
      id: DateTime.now().toIso8601String(),
      name: name,
      type: type,
      members: members,
      expenses: [],
      createdBy: currentUser.id,
    );
    groups.add(newGroup);
    notifyListeners();
  }

  void updateGroup(String groupId, String name, List<User> members) {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      final oldGroup = groups[index];
      groups[index] = Group(
        id: oldGroup.id,
        name: name,
        type: oldGroup.type,
        members: members,
        expenses: oldGroup.expenses,
        createdBy: oldGroup.createdBy,
      );
      notifyListeners();
    }
  }

  void deleteGroup(String groupId) {
    groups.removeWhere((g) => g.id == groupId);
    notifyListeners();
  }

  void addExpense(String groupId, Expense expense) {
    final groupIndex = groups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      groups[groupIndex].expenses.add(expense);
      notifyListeners();
    }
  }

  double getTotalYouOwe() {
    double totalOwe = 0;
    for (var group in groups) {
      for (var expense in group.expenses) {
        if (expense.payer.id != currentUser.id &&
            expense.splitBetween.contains(currentUser.id)) {
          // Basic equal split
          double share = expense.amount / expense.splitBetween.length;
          totalOwe += share;
        }
      }
    }
    return totalOwe;
  }

  double getTotalOwedToYou() {
    double totalOwed = 0;
    for (var group in groups) {
      for (var expense in group.expenses) {
        if (expense.payer.id == currentUser.id) {
          double myShare = expense.splitBetween.contains(currentUser.id)
              ? expense.amount / expense.splitBetween.length
              : 0;
          totalOwed += (expense.amount - myShare);
        }
      }
    }
    return totalOwed;
  }
}
