import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenses_tracker/models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final TransactionType transactionType;
  final Function(Transaction) onSave;
  final Transaction? initialTransaction;

  const TransactionForm({
    super.key,
    required this.transactionType,
    required this.onSave,
    this.initialTransaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // Get type-specific properties
  Color get _typeColor {
    switch (widget.transactionType) {
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.income:
        return Colors.green;
      case TransactionType.saving:
        return Colors.amber;
    }
  }

  String get _typeTitle {
    switch (widget.transactionType) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.saving:
        return 'Saving';
    }
  }

  List<String> get _categoryOptions {
    switch (widget.transactionType) {
      case TransactionType.expense:
        return [
          'Food',
          'Transport',
          'Entertainment',
          'Shopping',
          'Bills',
          'Other',
        ];
      case TransactionType.income:
        return ['Salary', 'Freelance', 'Gift', 'Investment', 'Other'];
      case TransactionType.saving:
        return [
          'Emergency Fund',
          'Retirement',
          'Vacation',
          'Education',
          'Home',
          'Other',
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize with existing transaction data if editing
    if (widget.initialTransaction != null) {
      _titleController.text = widget.initialTransaction!.title;
      _amountController.text = widget.initialTransaction!.amount.toString();
      _selectedDate = widget.initialTransaction!.date;
      _selectedCategory = widget.initialTransaction!.category;
      if (widget.initialTransaction!.note != null) {
        _noteController.text = widget.initialTransaction!.note!;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        note:
            _noteController.text.isNotEmpty
                ? _noteController.text.trim()
                : null,
      );

      widget.onSave(newTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Header
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add ${_typeTitle}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _typeColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter a title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Date Picker
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat.yMMMd().format(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items:
                      _categoryOptions.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Note Field
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (Optional)',
                    hintText: 'Add a note',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _typeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Save ${_typeTitle}'),
                  ),
                ),
                // Add some extra padding at the bottom to ensure the button is visible
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
