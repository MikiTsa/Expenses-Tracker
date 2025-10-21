import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expenses_tracker/models/transaction.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references for each transaction type
  CollectionReference get expensesCollection =>
      _firestore.collection('expenses');
  CollectionReference get incomesCollection => _firestore.collection('incomes');
  CollectionReference get savingsCollection => _firestore.collection('savings');

  // Get the correct collection based on transaction type
  CollectionReference _getCollection(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return expensesCollection;
      case TransactionType.income:
        return incomesCollection;
      case TransactionType.saving:
        return savingsCollection;
    }
  }

  // Add a new transaction
  Future<void> addTransaction(
    Transaction transaction,
    TransactionType type,
  ) async {
    try {
      await _getCollection(type).doc(transaction.id).set(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Update an existing transaction
  Future<void> updateTransaction(
    Transaction transaction,
    TransactionType type,
  ) async {
    try {
      await _getCollection(
        type,
      ).doc(transaction.id).update(transaction.toMap());
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id, TransactionType type) async {
    try {
      await _getCollection(type).doc(id).delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Get all transactions of a specific type as a stream
  Stream<List<Transaction>> getTransactionsStream(TransactionType type) {
    return _getCollection(type).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  // Get all transactions of a specific type (one-time fetch)
  Future<List<Transaction>> getTransactions(TransactionType type) async {
    try {
      final snapshot = await _getCollection(type).get();
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }
}
