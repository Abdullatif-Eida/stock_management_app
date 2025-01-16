import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/core/constants/app_constants.dart';
import 'package:stock_management/features/stocks/domain/models/product.dart';
import 'package:stock_management/features/stocks/domain/repositories/product_repository.dart';
import 'package:stock_management/features/stocks/presentation/states/product_state.dart';


class ProductViewModel extends StateNotifier<ProductState> {
  final ProductRepository _repository;

  ProductViewModel(this._repository) : super(const ProductState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true);
      final products = await _repository.getProducts();
      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      await loadProducts();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await _repository.deleteProduct(product.id);
      await loadProducts();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateStock(String id, int delta) async {
    try {
      final product = state.products.firstWhere((p) => p.id == id);
      final updatedProduct = product.copyWith(
        stock: product.stock + delta,
        lastUpdated: DateTime.now(),
      );
      await _repository.updateProduct(updatedProduct);
      await loadProducts();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void filterProducts(ProductFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void filterByPrice(PriceFilter priceFilter) {
    state = state.copyWith(priceFilter: priceFilter);
  }

  List<Product> get filteredProducts {
    return switch (state.filter) {
      ProductFilter.all => state.products,
      ProductFilter.inStock => 
        state.products.where((p) => p.stock > AppConstants.lowStockThreshold).toList(),
      ProductFilter.lowStock => 
        state.products.where((p) => p.stock <= AppConstants.lowStockThreshold && p.stock > 0).toList(),
      ProductFilter.outOfStock => 
        state.products.where((p) => p.stock == 0).toList(),
    };
  }
}