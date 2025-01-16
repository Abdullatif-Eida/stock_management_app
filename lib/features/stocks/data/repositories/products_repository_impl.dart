import 'package:sqflite/sqflite.dart';
import 'package:stock_management/core/constants/app_constants.dart';
import 'package:stock_management/features/stocks/data/datasources/product_database.dart';
import 'package:stock_management/features/stocks/domain/models/product.dart';
import 'package:stock_management/features/stocks/domain/repositories/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductDatabase database;

  ProductRepositoryImpl(this.database);

  @override
  Future<List<Product>> getProducts() async {
    final db = await database.database;
    final List<Map<String, dynamic>> maps = await db.query(AppConstants.dbTable);
    
    return maps.map((map) => Product.fromJson(map)).toList();
  }

  @override
  Future<void> addProduct(Product product) async {
    final db = await database.database;
    await db.insert(
      AppConstants.dbTable,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateProduct(Product product) async {
    final db = await database.database;
    await db.update(
      AppConstants.dbTable,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    final db = await database.database;
    await db.delete(
      AppConstants.dbTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}