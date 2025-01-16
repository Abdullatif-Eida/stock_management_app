import 'package:flutter/material.dart';

class StockStatusIndicator extends StatelessWidget {
  final int stock;

  const StockStatusIndicator({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    if (stock == 0) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      text = 'Out of Stock';
    } else if (stock < 5) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
      text = 'Low Stock';
    } else {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      text = 'In Stock';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}