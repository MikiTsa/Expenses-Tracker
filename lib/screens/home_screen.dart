import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/screens/expenses_screen.dart';
import 'package:expenses_tracker/screens/incomes_screen.dart';
import 'package:expenses_tracker/screens/savings_screen.dart';
import 'package:expenses_tracker/widgets/balance_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Transaction> expenses = [];
  List<Transaction> incomes = [];
  List<Transaction> savings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen for tab changes to update the state
    _tabController.addListener(() {
      // Force rebuild when tab changes (to update balance display)
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Calculate current balance based on incomes, expenses, and savings
  double get currentBalance {
    double income = incomes.fold(0, (sum, item) => sum + item.amount);
    double expense = expenses.fold(0, (sum, item) => sum + item.amount);
    double saving = savings.fold(0, (sum, item) => sum + item.amount);
    return income - expense - saving;
  }

  // Calculate total savings
  double get totalSavings {
    return savings.fold(0, (sum, item) => sum + item.amount);
  }

  // Add new transaction of appropriate type
  void addTransaction(Transaction transaction, TransactionType type) {
    setState(() {
      switch (type) {
        case TransactionType.expense:
          expenses.add(transaction);
          break;
        case TransactionType.income:
          incomes.add(transaction);
          break;
        case TransactionType.saving:
          savings.add(transaction);
          break;
      }
    });
  }

  // Edit existing transaction
  void editTransaction(Transaction updatedTransaction, TransactionType type) {
    setState(() {
      switch (type) {
        case TransactionType.expense:
          final index = expenses.indexWhere(
            (t) => t.id == updatedTransaction.id,
          );
          if (index != -1) {
            expenses[index] = updatedTransaction;
          }
          break;
        case TransactionType.income:
          final index = incomes.indexWhere(
            (t) => t.id == updatedTransaction.id,
          );
          if (index != -1) {
            incomes[index] = updatedTransaction;
          }
          break;
        case TransactionType.saving:
          final index = savings.indexWhere(
            (t) => t.id == updatedTransaction.id,
          );
          if (index != -1) {
            savings[index] = updatedTransaction;
          }
          break;
      }
    });
  }

  // Remove a transaction
  void removeTransaction(String id, TransactionType type) {
    setState(() {
      switch (type) {
        case TransactionType.expense:
          expenses.removeWhere((transaction) => transaction.id == id);
          break;
        case TransactionType.income:
          incomes.removeWhere((transaction) => transaction.id == id);
          break;
        case TransactionType.saving:
          savings.removeWhere((transaction) => transaction.id == id);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar with our tab bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Expenses Tracker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TabBar(
                        controller: _tabController,
                        indicatorWeight: 3,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            child: Text(
                              'Expenses',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Incomes',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Savings',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Expenses Tab
                      ExpensesScreen(
                        expenses: expenses,
                        onAddExpense:
                            (transaction) => addTransaction(
                              transaction,
                              TransactionType.expense,
                            ),
                        onEditExpense:
                            (transaction) => editTransaction(
                              transaction,
                              TransactionType.expense,
                            ),
                        onRemoveTransaction: removeTransaction,
                      ),

                      // Incomes Tab
                      IncomesScreen(
                        incomes: incomes,
                        onAddIncome:
                            (transaction) => addTransaction(
                              transaction,
                              TransactionType.income,
                            ),
                        onEditIncome:
                            (transaction) => editTransaction(
                              transaction,
                              TransactionType.income,
                            ),
                        onRemoveTransaction: removeTransaction,
                      ),

                      // Savings Tab
                      SavingsScreen(
                        savings: savings,
                        onAddSaving:
                            (transaction) => addTransaction(
                              transaction,
                              TransactionType.saving,
                            ),
                        onEditSaving:
                            (transaction) => editTransaction(
                              transaction,
                              TransactionType.saving,
                            ),
                        onRemoveTransaction: removeTransaction,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating balance box - now positioned on the left side
            Positioned(
              left: 16,
              bottom: 20,
              child: BalanceBox(
                amount:
                    _tabController.index == 2 ? totalSavings : currentBalance,
                isSavings: _tabController.index == 2,
                activeTabIndex: _tabController.index,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
