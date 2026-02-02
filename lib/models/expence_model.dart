import 'user_model.dart';

class Expense {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final User payer;
  final List<String> splitBetween; // List of User IDs
  // For simplicity, we assume equal split for now, but can extend to specific shares

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.payer,
    required this.splitBetween,
  });
}
