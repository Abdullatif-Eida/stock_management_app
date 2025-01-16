import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/presentation/widgets/stock_status_indicator.dart';
import '../../domain/models/product.dart';
import '../providers/product_providers.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Row(
          children: [
            Text('Stock: ${product.stock}'),
            const SizedBox(width: 12),
            StockStatusIndicator(stock: product.stock),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: product.stock > 0
                  ? () => ref
                      .read(productViewModelProvider.notifier)
                      .updateStock(product.id, -1)
                  : null,
            ),
            Text('\$${product.price.toStringAsFixed(2)}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => ref
                  .read(productViewModelProvider.notifier)
                  .updateStock(product.id, 1),
            ),
          ],
        ),
      ),
    );
  }
}