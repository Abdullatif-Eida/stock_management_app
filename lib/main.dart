import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management/features/stocks/presentation/pages/product_list_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    // Wrap the app with ProviderScope for Riverpod
    const ProviderScope(
      child: StockManagementApp(),
    ),
  );
}

class StockManagementApp extends StatelessWidget {
  const StockManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stock Management',
      debugShowCheckedModeBanner: false,
      home: ProductListPage(),
    );
  }
}