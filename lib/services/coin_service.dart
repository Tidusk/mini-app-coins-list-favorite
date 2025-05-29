import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinService {
  // !!! SUBSTITUA PELO SEU TOKEN DE API REAL DA COINMARKETCAP !!!
  final String _apiKey = "1c12bdc9-2195-4c85-86fd-053e35b942a6";
  final String _baseUrl = "https://cors-anywhere.herokuapp.com/https://pro-api.coinmarketcap.com/v1/cryptocurrency";

  Future<List<dynamic>> getTop50Coins() async {
    final url = Uri.parse('$_baseUrl/listings/latest?start=1&limit=50&convert=USD');
    final response = await http.get(
      url,
      headers: {
        'X-CMC_PRO_API_KEY': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      // Tratar erros, talvez lançar uma exceção ou retornar uma lista vazia
      // print('Erro ao buscar dados da CoinMarketCap: ${response.statusCode}'); // Commented out print
      // print('Corpo da resposta de erro: ${response.body}'); // Commented out print
      throw Exception('Falha ao carregar dados das criptomoedas: ${response.statusCode}'); // Incluído status code na exceção
    }
  }
}
