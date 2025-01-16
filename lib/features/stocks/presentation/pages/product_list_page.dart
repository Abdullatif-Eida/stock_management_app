import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/presentation/pages/add_product.dart';
import 'package:stock_management/features/stocks/presentation/states/product_state.dart';
import 'package:stock_management/features/stocks/presentation/widgets/product_filter.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productViewModelProvider);

    Widget buildBody() {
      if (productState.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (productState.error != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${productState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(productViewModelProvider.notifier).loadProducts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final filteredProducts = ref.watch(
        productViewModelProvider.select(
          (state) {
            var filtered = state.products.where((p) {
              bool matchesStockFilter = switch (state.filter) {
                ProductFilter.all => true,
                ProductFilter.inStock => p.stock > 0,
                ProductFilter.outOfStock => p.stock == 0,
                ProductFilter.lowStock => p.stock > 0 && p.stock < 5,
              };

              bool matchesPriceFilter = switch (state.priceFilter) {
                PriceFilter.all => true,
                PriceFilter.under50 => p.price < 50,
                PriceFilter.under100 => p.price < 100,
                PriceFilter.over100 => p.price >= 100,
                _ => true,
              };

              return matchesStockFilter && matchesPriceFilter;
            }).toList();

            if (state.priceFilter == PriceFilter.lowToHigh) {
              filtered.sort((a, b) => a.price.compareTo(b.price));
            } else if (state.priceFilter == PriceFilter.highToLow) {
              filtered.sort((a, b) => b.price.compareTo(a.price));
            }

            return filtered;
          },
        ),
      );

      if (filteredProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                productState.filter == ProductFilter.all
                    ? 'No products available'
                    : 'No products match the selected filter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Dismissible(
            key: Key(product.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Product'),
                  content:
                      Text('Are you sure you want to delete ${product.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              ref
                  .read(productViewModelProvider.notifier)
                  .deleteProduct(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      ref
                          .read(productViewModelProvider.notifier)
                          .addProduct(product);
                    },
                  ),
                ),
              );
            },
            child: ProductCard(product: product),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: const [
          ProductFilterWidget(),
        ],
      ),
      body: SafeArea(
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
