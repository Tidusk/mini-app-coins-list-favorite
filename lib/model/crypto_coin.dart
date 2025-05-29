class CryptoCoin {
  final int id;
  final String name;
  final String symbol;
  final double price;
  final double percentChange24h;

  CryptoCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentChange24h,
  });

  // Factory method para criar uma instância de CryptoCoin a partir de um mapa JSON
  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    final quote = json['quote']['USD']; // Acessa os dados de USD dentro de quote
    return CryptoCoin(
      id: json['id'],
      name: json['name'],
      // Acessa o símbolo diretamente do mapa JSON principal
      symbol: json['symbol'],
      // Garante que os valores numéricos sejam tratados como double, mesmo que venham como int
      price: quote['price'].toDouble(),
      percentChange24h: quote['percent_change_24h'].toDouble(),
    );
  }
}
