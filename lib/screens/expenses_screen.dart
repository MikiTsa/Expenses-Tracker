import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/transaction_form.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';

class ExpensesScreen extends StatelessWidget {
  final List<Transaction> expenses;
  final Function(Transaction) onAddExpense;

  const ExpensesScreen({
    super.key,
    required this.expenses,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          expenses.isEmpty
              ? _buildEmptyState(context)
              : TransactionList(
                transactions: expenses,
                transactionType: TransactionType.expense,
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () => _showAddExpenseForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add an expense',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionForm(
            transactionType: TransactionType.expense,
            onSave: onAddExpense,
          ),
    );
  }
}
