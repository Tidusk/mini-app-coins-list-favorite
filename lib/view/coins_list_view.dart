import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/crypto_coin.dart';
import '../services/coin_service.dart';
import '../controller/auth_controller.dart';

class CoinsListView extends StatefulWidget {
  const CoinsListView({super.key});

  @override
  CoinsListViewState createState() => CoinsListViewState();
}

class CoinsListViewState extends State<CoinsListView> {
  late Future<List<CryptoCoin>> _coinsFuture;

  @override
  void initState() {
    super.initState();
    _coinsFuture = _fetchCoins();
  }

  Future<List<CryptoCoin>> _fetchCoins() async {
    final data = await CoinService().getTop50Coins();
    return data.map((json) => CryptoCoin.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return FutureBuilder<List<CryptoCoin>>(
      future: _coinsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar moedas: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma moeda encontrada.'));
        } else {
          final coins = snapshot.data!;
          return ListView.builder(
            itemCount: coins.length,
            itemBuilder: (context, index) {
              final coin = coins[index];
              return Consumer<AuthController>(
                builder: (context, auth, child) {
                  final isFavorite = auth.isFavorite(coin);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Increased margin
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Increased padding
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).round()), // Subtle background
                            child: Text(
                              coin.symbol[0].toUpperCase(), // Uppercase symbol initial
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold), // Themed text color
                            ),
                          ),
                          const SizedBox(width: 16.0), // Spacing
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${coin.name} (${coin.symbol.toUpperCase()})', // Uppercase symbol
                                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4.0), // Spacing
                                Text(
                                  'Price: \$${coin.price.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]), // Slightly muted color
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${coin.percentChange24h.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: coin.percentChange24h > 0 ? Colors.green : Colors.redAccent, // Color based on change
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: isFavorite ? Theme.of(context).colorScheme.secondary : Colors.grey[400], // Themed favorite color
                                ),
                                onPressed: () => authController.toggleFavorite(coin),
                                tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites', // Added tooltip
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
