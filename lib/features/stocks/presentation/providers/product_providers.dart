import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/data/datasources/product_database.dart';
import 'package:stock_management/features/stocks/data/repositories/products_repository_impl.dart';
import 'package:stock_management/features/stocks/domain/repositories/product_repository.dart';
import 'package:stock_management/features/stocks/presentation/states/product_state.dart';
import 'package:stock_management/features/stocks/presentation/viewmodels/product_viewmodel.dart';


final productDatabaseProvider = Provider<ProductDatabase>((ref) {
  return ProductDatabase();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final database = ref.watch(productDatabaseProvider);
  return ProductRepositoryImpl(database);
});

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductViewModel(repository);
});