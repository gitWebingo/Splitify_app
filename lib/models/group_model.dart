import 'expence_model.dart';
import 'user_model.dart';

class Group {
  final String id;
  final String name;
  final String type; // e.g., "Trip", "Home", "Couple", "Other"
  final List<User> members;
  final List<Expense> expenses;
  final String? createdBy;

  Group({
    required this.id,
    required this.name,
    required this.type,
    required this.members,
    required this.expenses,
    this.createdBy,
  });

  double get totalExpenses {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  String get memberNames {
    if (members.isEmpty) return 'No members';
    if (members.length <= 3) {
      return members.map((e) => e.name).join(', ');
    }
    return '${members.take(2).map((e) => e.name).join(', ')} and ${members.length - 2} others';
  }
}
