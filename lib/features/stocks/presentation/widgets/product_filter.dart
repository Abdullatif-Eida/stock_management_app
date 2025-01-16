import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/presentation/providers/product_providers.dart';
import 'package:stock_management/features/stocks/presentation/states/product_state.dart';

class ProductFilterWidget extends ConsumerWidget {
  const ProductFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stock Filter
        PopupMenuButton<ProductFilter>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter by stock',
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
              child: Text('In Stock'),
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
        ),
        // Price Filter
        PopupMenuButton<PriceFilter>(
          icon: const Icon(Icons.attach_money),
          tooltip: 'Filter by price',
          onSelected: (priceFilter) {
            ref.read(productViewModelProvider.notifier).filterByPrice(priceFilter);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: PriceFilter.all,
              child: Text('All Prices'),
            ),
            const PopupMenuItem(
              value: PriceFilter.lowToHigh,
              child: Text('Price: Low to High'),
            ),
            const PopupMenuItem(
              value: PriceFilter.highToLow,
              child: Text('Price: High to Low'),
            ),
            const PopupMenuItem(
              value: PriceFilter.under50,
              child: Text('Under \$50'),
            ),
            const PopupMenuItem(
              value: PriceFilter.under100,
              child: Text('Under \$100'),
            ),
            const PopupMenuItem(
              value: PriceFilter.over100,
              child: Text('Over \$100'),
            ),
          ],
        ),
      ],
    );
  }
}