import 'package:flutter/material.dart';

class BalanceBox extends StatelessWidget {
  final double amount;
  final bool isSavings;
  final int activeTabIndex;

  const BalanceBox({
    super.key,
    required this.amount,
    required this.isSavings,
    required this.activeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Format the amount string
    String formattedAmount = amount.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isSavings ? 'Total Savings' : 'Current Balance',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$$formattedAmount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    // Get the color based on the active tab index with increased transparency
    switch (activeTabIndex) {
      case 0: // Expenses tab
        return Colors.red.withOpacity(0.6);
      case 1: // Incomes tab
        return Colors.green.withOpacity(0.6);
      case 2: // Savings tab
        return Colors.amber.withOpacity(0.6);
      default:
        return Colors.black.withOpacity(0.5);
    }
  }
}
