import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quote {
  final String text, author;
  const Quote(this.text, this.author);
  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        (json['quote'] ?? '').toString().trim(),
        (json['author'] ?? 'Unknown').toString(),
      );
  Map<String, dynamic> toJson() => {'quote': text, 'author': author};
  String get message => '“$text”\n— $author';
  bool matches(Quote other) => text == other.text && author == other.author;
}

Future<Quote?> fetchQuote() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'))
      .timeout(const Duration(seconds: 15));
  if (response.statusCode == 204) return null;
  if (response.statusCode != 200) {
    throw Exception('Server error: ${response.statusCode}');
  }
  if (response.body.trim().isEmpty) return null;
  final data = jsonDecode(response.body);
  if (data == null) return null;
  if (data is! Map<String, dynamic>) throw const FormatException('Invalid response');
  final quote = Quote.fromJson(data);
  return quote.text.isEmpty ? null : quote;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favorites = ValueNotifier<List<Quote>>([]);
  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('favorites');
    if (saved != null) {
      favorites.value = (jsonDecode(saved) as List)
          .map((item) => Quote.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
  } catch (_) { /* Continue with an empty list if storage is unavailable. */ }
  runApp(QuoteApp(favorites: favorites, prefs: prefs));
}

class QuoteApp extends StatelessWidget {
  final ValueNotifier<List<Quote>> favorites;
  final SharedPreferences? prefs;
  const QuoteApp({super.key, required this.favorites, required this.prefs});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: QuoteScreen(favorites: favorites, prefs: prefs),
      );
}

Future<void> toggleFavorite(BuildContext context, ValueNotifier<List<Quote>> favorites,
    SharedPreferences? prefs, Quote quote) async {
  final updated = [...favorites.value];
  if (updated.any(quote.matches)) {
    updated.removeWhere(quote.matches);
  } else {
    updated.add(quote);
  }
  favorites.value = updated;
  try {
    if (prefs == null || !await prefs.setString('favorites', jsonEncode(updated.map((q) => q.toJson()).toList()))) {
      throw Exception('Storage unavailable');
    }
  } catch (_) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorites updated for this session only.')));
  }
}

Future<void> shareQuote(BuildContext context, Quote quote) async {
  try {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(quote.message, sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size);
  } catch (_) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to share this quote.')));
  }
}

class QuoteScreen extends StatefulWidget {
  final ValueNotifier<List<Quote>> favorites;
  final SharedPreferences? prefs;
  const QuoteScreen({super.key, required this.favorites, required this.prefs});
  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late Future<Quote?> future;
  @override
  void initState() {
    super.initState();
    future = fetchQuote();
  }
  void refresh() => setState(() { future = fetchQuote(); });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Quote App'), actions: [
      IconButton(tooltip: 'Favorite quotes', icon: const Icon(Icons.favorite),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
          FavoritesScreen(favorites: widget.favorites, prefs: widget.prefs)))),
    ]),
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
      child: FutureBuilder<Quote?>(future: future, builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off, size: 48),
            const Text('Unable to load quote. Check your internet connection.', textAlign: TextAlign.center),
            FilledButton(onPressed: refresh, child: const Text('Retry')),
          ]);
        }
        final quote = snapshot.data;
        if (quote == null) return Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('No quote available.'),
          FilledButton(onPressed: refresh, child: const Text('Try again')),
        ]);
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
            const Icon(Icons.format_quote, size: 48),
            Text(quote.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16), Text('— ${quote.author}'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ValueListenableBuilder<List<Quote>>(valueListenable: widget.favorites,
                builder: (context, items, _) => IconButton(tooltip: 'Toggle favorite',
                  icon: Icon(items.any(quote.matches) ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () => toggleFavorite(context, widget.favorites, widget.prefs, quote))),
              Builder(builder: (context) => IconButton(tooltip: 'Share', icon: const Icon(Icons.share),
                onPressed: () => shareQuote(context, quote))),
            ]),
          ]))),
          const SizedBox(height: 20),
          FilledButton(onPressed: refresh, child: const Text('Another Quote')),
        ]);
      }),
    )),
  );
}

class FavoritesScreen extends StatelessWidget {
  final ValueNotifier<List<Quote>> favorites;
  final SharedPreferences? prefs;
  const FavoritesScreen({super.key, required this.favorites, required this.prefs});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorite Quotes')),
    body: ValueListenableBuilder<List<Quote>>(valueListenable: favorites,
      builder: (context, items, _) {
        if (items.isEmpty) return const Center(child: Text('No favorite quotes yet.'));
        return ListView.builder(itemCount: items.length, itemBuilder: (context, index) {
          final quote = items[index];
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(title: Text(quote.text), subtitle: Text(quote.author),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Builder(builder: (context) => IconButton(tooltip: 'Share', icon: const Icon(Icons.share),
                  onPressed: () => shareQuote(context, quote))),
                IconButton(tooltip: 'Remove favorite', icon: const Icon(Icons.delete_outline),
                  onPressed: () => toggleFavorite(context, favorites, prefs, quote)),
              ])));
        });
      }),
  );
}
