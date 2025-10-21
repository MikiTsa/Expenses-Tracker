import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

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

  // Convert Transaction to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'category': category,
      'note': note,
    };
  }

  // Create Transaction from Firestore document
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      category: map['category'] as String?,
      note: map['note'] as String?,
    );
  }

  // Create Transaction from Firestore DocumentSnapshot
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Transaction.fromMap(data);
  }
}
