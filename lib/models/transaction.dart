import 'package:uuid/uuid.dart';

// Enum to represent transaction types
enum TransactionType { expense, income, saving }

// Transaction model for all financial entries
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? note;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.note,
  }) : id = id ?? const Uuid().v4();

  // Create a copy of the transaction with some modified fields
  Transaction copyWith({
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? note,
  }) {
    return Transaction(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
