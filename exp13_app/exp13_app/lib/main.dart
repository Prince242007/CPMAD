import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (_) => ShopState()..load(), child: const ShoppingApp(),
));

String money(double value) => '\$${value.toStringAsFixed(2)}';

class Product {
  final int id;
  final String title, category, description, image;
  final double price, rating;
  const Product(this.id, this.title, this.category, this.description,
      this.image, this.price, this.rating);
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    json['id'] as int, json['title'] as String, json['category'] as String,
    json['description'] as String, json['image'] as String,
    (json['price'] as num).toDouble(),
    (json['rating']['rate'] as num).toDouble(),
  );
}

class ShopState extends ChangeNotifier {
  List<Product> products = [];
  final Map<int, int> cart = {};
  final Set<int> wishlist = {}, comparison = {};
  bool loading = false;
  String? error;
  String search = '', category = 'All';

  Future<void> load() async {
    if (loading) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) throw Exception('HTTP ${response.statusCode}');
      final data = jsonDecode(response.body) as List<dynamic>;
      products = data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      final ids = products.map((p) => p.id).toSet();
      cart.removeWhere((id, _) => !ids.contains(id));
      wishlist.retainAll(ids);
      comparison.retainAll(ids);
      if (!categories.contains(category)) category = 'All';
    } catch (_) {
      error = 'Could not load products. Check your internet and try again.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<String> get categories => ['All', ...products.map((p) => p.category).toSet()];
  List<Product> get filtered => products.where((p) =>
      (category == 'All' || p.category == category) &&
      p.title.toLowerCase().contains(search.trim().toLowerCase())).toList();
  List<Product> get cartProducts => products.where((p) => cart.containsKey(p.id)).toList();
  List<Product> get savedProducts => products.where((p) => wishlist.contains(p.id)).toList();
  List<Product> get comparedProducts => products.where((p) => comparison.contains(p.id)).toList();
  int quantity(Product p) => cart[p.id] ?? 0;
  int get itemCount => cart.values.fold(0, (a, b) => a + b);
  double subtotal(Product p) => p.price * quantity(p);
  double get total => cartProducts.fold<double>(0, (sum, p) => sum + subtotal(p));
  void setSearch(String value) { search = value; notifyListeners(); }
  void setCategory(String value) { category = value; notifyListeners(); }
  void add(Product p) { cart[p.id] = quantity(p) + 1; notifyListeners(); }
  void remove(Product p) {
    if (quantity(p) <= 1) { cart.remove(p.id); } else { cart[p.id] = quantity(p) - 1; }
    notifyListeners();
  }
  void delete(Product p) { cart.remove(p.id); notifyListeners(); }
  void toggleWishlist(Product p) {
    if (!wishlist.add(p.id)) wishlist.remove(p.id);
    notifyListeners();
  }
  void toggleCompare(Product p) {
    if (!comparison.add(p.id)) comparison.remove(p.id);
    notifyListeners();
  }
  void clearCompare() { comparison.clear(); notifyListeners(); }
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Shopping Cart',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Scaffold(
      appBar: AppBar(title: Text(['Products', 'Wishlist', 'Cart', 'Compare'][index]),
        actions: [IconButton(onPressed: shop.loading ? null : shop.load,
          icon: const Icon(Icons.refresh), tooltip: 'Refresh products')]),
      body: IndexedStack(index: index, children: const [
        ProductsScreen(), WishlistScreen(), CartScreen(), CompareScreen(),
      ]),
      bottomNavigationBar: NavigationBar(selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.store), label: 'Shop'),
          const NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart (${shop.itemCount})'),
          NavigationDestination(icon: const Icon(Icons.compare_arrows), label: 'Compare (${shop.comparison.length})'),
        ]),
    );
  }
}

class ProductImage extends StatelessWidget {
  final Product product;
  final double size;
  const ProductImage(this.product, {super.key, this.size = 80});
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size,
    child: Image.network(product.image, fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      loadingBuilder: (context, child, progress) => progress == null ? child :
        const Center(child: CircularProgressIndicator(strokeWidth: 2))),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
        Row(children: [ProductImage(product), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.category), Text('${money(product.price)}  •  Rating: ${product.rating}'),
          ])),
          IconButton(tooltip: 'Toggle wishlist', onPressed: () => shop.toggleWishlist(product),
            icon: Icon(shop.wishlist.contains(product.id) ? Icons.favorite : Icons.favorite_border,
              color: shop.wishlist.contains(product.id) ? Colors.red : null)),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          FilterChip(label: const Text('Compare'), selected: shop.comparison.contains(product.id),
            onSelected: (_) => shop.toggleCompare(product)),
          FilledButton.icon(onPressed: () => shop.add(product), icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart')),
        ]),
      ])),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    if (shop.loading) return const Center(child: CircularProgressIndicator());
    if (shop.error != null) return Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(shop.error!, textAlign: TextAlign.center),
        const SizedBox(height: 12), ElevatedButton(onPressed: shop.load, child: const Text('Retry')),
      ])));
    final products = shop.filtered;
    return Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Column(children: [
        TextFormField(initialValue: shop.search, onChanged: shop.setSearch,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search products', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: shop.category, isExpanded: true,
          decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
          items: shop.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (c) { if (c != null) shop.setCategory(c); }),
      ])),
      Expanded(child: products.isEmpty ? const Center(child: Text('No products found')) :
        ListView.builder(itemCount: products.length, itemBuilder: (_, i) => ProductCard(products[i]))),
    ]);
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ShopState>().savedProducts;
    return products.isEmpty ? const Center(child: Text('Your wishlist is empty')) :
      ListView.builder(itemCount: products.length, itemBuilder: (_, i) => ProductCard(products[i]));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    final products = shop.cartProducts;
    if (products.isEmpty) return const Center(child: Text('Your cart is empty'));
    return Column(children: [
      Expanded(child: ListView.builder(itemCount: products.length, itemBuilder: (_, i) {
        final p = products[i];
        return Card(margin: const EdgeInsets.all(8), child: Padding(padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(children: [ProductImage(p, size: 60), const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.title), Text('Unit price: ${money(p.price)}'),
                Text('Subtotal: ${money(shop.subtotal(p))}'),
              ])), IconButton(onPressed: () => shop.delete(p), icon: const Icon(Icons.delete_outline), tooltip: 'Remove product'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(onPressed: () => shop.remove(p), icon: const Icon(Icons.remove_circle_outline)),
              Text('Qty: ${shop.quantity(p)}'),
              IconButton(onPressed: () => shop.add(p), icon: const Icon(Icons.add_circle_outline)),
            ]),
          ])));
      })),
      Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Total quantity: ${shop.itemCount}'),
        Text('Cart subtotal: ${money(shop.total)}'),
        Text('Total: ${money(shop.total)}', style: Theme.of(context).textTheme.headlineSmall),
      ])),
    ]);
  }
}

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    final products = shop.comparedProducts;
    if (products.length < 2) return Center(child: Padding(padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Select at least two products using Compare on the Shop screen.\nSelected: ${products.length}', textAlign: TextAlign.center),
        if (products.isNotEmpty) TextButton(onPressed: shop.clearCompare, child: const Text('Clear selection')),
      ])));
    DataRow row(String label, Widget Function(Product) cell) => DataRow(cells: [
      DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
      ...products.map((p) => DataCell(SizedBox(width: 150, child: cell(p)))),
    ]);
    return Column(children: [
      Padding(padding: const EdgeInsets.all(8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${products.length} products selected'), TextButton(onPressed: shop.clearCompare, child: const Text('Clear all')),
      ])),
      Expanded(child: SingleChildScrollView(child: SingleChildScrollView(scrollDirection: Axis.horizontal,
        child: DataTable(dataRowMinHeight: 56, dataRowMaxHeight: 180,
          columns: [const DataColumn(label: Text('Attribute')),
            ...List.generate(products.length, (i) => DataColumn(label: Text('Product ${i + 1}')))],
          rows: [
            row('Image', (p) => ProductImage(p, size: 70)),
            row('Name', (p) => Text(p.title)),
            row('Price', (p) => Text(money(p.price))),
            row('Category', (p) => Text(p.category)),
            row('Rating', (p) => Text('${p.rating} / 5')),
            row('Description', (p) => SingleChildScrollView(child: Text(p.description))),
            row('Action', (p) => TextButton(onPressed: () => shop.toggleCompare(p), child: const Text('Remove'))),
          ])))),
    ]);
  }
}
