import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/transaction_form.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';

class IncomesScreen extends StatelessWidget {
  final List<Transaction> incomes;
  final Function(Transaction) onAddIncome;
  final Function(Transaction) onEditIncome;
  final Function(String, TransactionType) onRemoveTransaction;

  const IncomesScreen({
    super.key,
    required this.incomes,
    required this.onAddIncome,
    required this.onEditIncome,
    required this.onRemoveTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          incomes.isEmpty
              ? _buildEmptyState(context)
              : TransactionList(
                transactions: incomes,
                transactionType: TransactionType.income,
                onRemoveTransaction: onRemoveTransaction,
                onEditTransaction:
                    (transaction) => _showEditIncomeForm(context, transaction),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _showAddIncomeForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No incomes recorded',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add an income',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showAddIncomeForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionForm(
            transactionType: TransactionType.income,
            onSave: onAddIncome,
          ),
    );
  }

  void _showEditIncomeForm(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionForm(
            transactionType: TransactionType.income,
            initialTransaction: transaction,
            onSave: onEditIncome,
          ),
    );
  }
}
