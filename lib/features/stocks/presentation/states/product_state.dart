import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stock_management/features/stocks/domain/models/product.dart';
part 'product_state.freezed.dart';

enum ProductFilter { all, inStock, lowStock, outOfStock }

enum PriceFilter {
  all,
  lowToHigh,
  highToLow,
  under50,
  under100,
  over100
}

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    @Default([]) List<Product> products,
    @Default(ProductFilter.all) ProductFilter filter,
    @Default(PriceFilter.all) PriceFilter priceFilter,
    @Default(false) bool isLoading,
    String? error,
  }) = _ProductState;
}