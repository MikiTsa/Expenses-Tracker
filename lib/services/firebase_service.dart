import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expenses_tracker/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Collection references for each transaction type (USER-SPECIFIC)
  CollectionReference? get expensesCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('expenses');
  }

  CollectionReference? get incomesCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('incomes');
  }

  CollectionReference? get savingsCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('savings');
  }

  // Get the correct collection based on transaction type
  CollectionReference? _getCollection(TransactionType type) {
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
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final collection = _getCollection(type);
      if (collection == null) {
        throw Exception('Failed to get collection');
      }

      await collection.doc(transaction.id).set(transaction.toMap());
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
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final collection = _getCollection(type);
      if (collection == null) {
        throw Exception('Failed to get collection');
      }

      await collection.doc(transaction.id).update(transaction.toMap());
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id, TransactionType type) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final collection = _getCollection(type);
      if (collection == null) {
        throw Exception('Failed to get collection');
      }

      await collection.doc(id).delete();
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Get all transactions of a specific type as a stream
  Stream<List<Transaction>> getTransactionsStream(TransactionType type) {
    if (_currentUserId == null) {
      return Stream.value([]); // Return empty stream if not authenticated
    }

    final collection = _getCollection(type);
    if (collection == null) {
      return Stream.value([]);
    }

    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  // Get all transactions of a specific type (one-time fetch)
  Future<List<Transaction>> getTransactions(TransactionType type) async {
    try {
      if (_currentUserId == null) {
        return [];
      }

      final collection = _getCollection(type);
      if (collection == null) {
        return [];
      }

      final snapshot = await collection.get();
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }
}
