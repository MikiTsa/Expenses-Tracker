import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/transaction_form.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';

class SavingsScreen extends StatelessWidget {
  final List<Transaction> savings;
  final Function(Transaction) onAddSaving;
  final Function(Transaction) onEditSaving;
  final Function(String, TransactionType) onRemoveTransaction;

  const SavingsScreen({
    super.key,
    required this.savings,
    required this.onAddSaving,
    required this.onEditSaving,
    required this.onRemoveTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          savings.isEmpty
              ? _buildEmptyState(context)
              : TransactionList(
                transactions: savings,
                transactionType: TransactionType.saving,
                onRemoveTransaction: onRemoveTransaction,
                onEditTransaction:
                    (transaction) => _showEditSavingForm(context, transaction),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        onPressed: () => _showAddSavingForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.savings_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No savings recorded',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a saving',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showAddSavingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionForm(
            transactionType: TransactionType.saving,
            onSave: onAddSaving,
          ),
    );
  }

  void _showEditSavingForm(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionForm(
            transactionType: TransactionType.saving,
            initialTransaction: transaction,
            onSave: onEditSaving,
          ),
    );
  }
}
