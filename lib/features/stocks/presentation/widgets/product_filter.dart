import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/presentation/providers/product_providers.dart';
import 'package:stock_management/features/stocks/presentation/states/product_state.dart';

class ProductFilterWidget extends ConsumerWidget {
  const ProductFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ProductFilter>(
      icon: const Icon(Icons.filter_list),
      onSelected: (filter) {
        ref.read(productViewModelProvider.notifier).filterProducts(filter);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ProductFilter.all,
          child: Text('All Products'),
        ),
        const PopupMenuItem(
          value: ProductFilter.inStock,
          child:Text('In Stock'),
        ),
        const PopupMenuItem(
          value: ProductFilter.lowStock,
          child: Text('Low Stock'),
        ),
        const PopupMenuItem(
          value: ProductFilter.outOfStock,
          child: Text('Out of Stock'),
        ),
      ],
    );
  }
}