import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Removed unused import: import '../model/crypto_coin.dart';
import '../controller/auth_controller.dart'; // Import AuthController
// import '../services/firestore_service.dart'; // Removed FirestoreService import
// import '../services/coin_service.dart'; // CoinService might still be needed to fetch details if the AuthController only stores symbols/IDs, but for now, assuming full coin objects are stored.

// Changed back to StatefulWidget if state management within the view is needed, or keep StatelessWidget and rely solely on Provider
// Keeping as StatelessWidget and relying on Provider for simplicity given the local storage requirement.
class FavoritesListView extends StatelessWidget {
  const FavoritesListView({super.key}); // Added const

  // Removed service instances
  // final FirestoreService _firestoreService = FirestoreService();
  // final CoinService _coinService = CoinService(); // Assuming full coin objects are stored in AuthController

  // Removed _fetchFavoriteCoinsDetails as we will get full objects from AuthController
  // Future<List<CryptoCoin>> _fetchFavoriteCoinsDetails(List<String> symbols) async {
  //     if (symbols.isEmpty) {
  //        return [];
  //     }
  //     final allCoins = await _coinService.getTop50Coins();
  //     return allCoins.where((coin) => symbols.contains(coin.symbol)).toList().cast<CryptoCoin>();
  // }

  @override
  Widget build(BuildContext context) {
    // Access AuthController using Provider
    // Use Consumer to listen for changes in AuthController's favorites list
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        final favoriteCoins = auth.favoriteCoins;

        // Lida com o caso de dados nulos ou vazios (sem favoritos)
        if (favoriteCoins.isEmpty) {
          return const Center(child: Text('Você ainda não tem favoritos.'));
        }

        // Exibe a lista de moedas favoritas diretamente do AuthController
        return ListView.builder(
          itemCount: favoriteCoins.length,
          itemBuilder: (context, index) {
            final coin = favoriteCoins[index];

            return ListTile(
               leading: CircleAvatar(child: Text(coin.symbol[0])),
               title: Text('${coin.name} (${coin.symbol})'),
               subtitle: Text('Preço: \$${coin.price.toStringAsFixed(2)}'),
               trailing: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text('${coin.percentChange24h.toStringAsFixed(2)}%'),
                   IconButton(
                     icon: const Icon( // Ícone de estrela preenchida
                       Icons.star,
                       color: Colors.amber, // Cor de destaque para favoritos
                     ),
                     onPressed: () {
                        // Call toggleFavorite from AuthController to remove
                        auth.toggleFavorite(coin);
                     },
                   ),
                 ],
               ),
            );
          },
        );
      },
    );
  }
}
