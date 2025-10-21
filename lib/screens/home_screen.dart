import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/screens/expenses_screen.dart';
import 'package:expenses_tracker/screens/incomes_screen.dart';
import 'package:expenses_tracker/screens/savings_screen.dart';
import 'package:expenses_tracker/widgets/balance_box.dart';
import 'package:expenses_tracker/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();

  // These will now be populated from Firebase streams
  List<Transaction> expenses = [];
  List<Transaction> incomes = [];
  List<Transaction> savings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    // Listen to Firebase streams
    _setupFirebaseListeners();
  }

  // Setup real-time listeners for all transaction types
  void _setupFirebaseListeners() {
    // Listen to expenses
    _firebaseService.getTransactionsStream(TransactionType.expense).listen((
      transactions,
    ) {
      setState(() {
        expenses = transactions;
      });
    });

    // Listen to incomes
    _firebaseService.getTransactionsStream(TransactionType.income).listen((
      transactions,
    ) {
      setState(() {
        incomes = transactions;
      });
    });

    // Listen to savings
    _firebaseService.getTransactionsStream(TransactionType.saving).listen((
      transactions,
    ) {
      setState(() {
        savings = transactions;
      });
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

  // Add transaction to Firebase
  Future<void> addTransaction(
    Transaction transaction,
    TransactionType type,
  ) async {
    try {
      await _firebaseService.addTransaction(transaction, type);
      // No need to call setState - the stream listener will update automatically
    } catch (e) {
      _showErrorSnackBar('Failed to add transaction');
    }
  }

  // Edit transaction in Firebase
  Future<void> editTransaction(
    Transaction updatedTransaction,
    TransactionType type,
  ) async {
    try {
      await _firebaseService.updateTransaction(updatedTransaction, type);
      // No need to call setState - the stream listener will update automatically
    } catch (e) {
      _showErrorSnackBar('Failed to update transaction');
    }
  }

  // Remove transaction from Firebase
  Future<void> removeTransaction(String id, TransactionType type) async {
    try {
      await _firebaseService.deleteTransaction(id, type);
      // No need to call setState - the stream listener will update automatically
    } catch (e) {
      _showErrorSnackBar('Failed to delete transaction');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar with title and tab bar
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
                      // Title
                      const Text(
                        'Expenses Tracker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tab Bar with color-coded tabs
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

            // Floating balance box - positioned on the left side
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
