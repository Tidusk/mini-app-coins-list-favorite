import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/crypto_coin.dart'; // Import CryptoCoin model

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Local list to store favorite coins temporarily
  final List<CryptoCoin> _favoriteCoins = [];

  // Stream para observar as mudanças no estado de autenticação do usuário
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Obter o usuário atualmente logado
  User? get currentUser => _auth.currentUser;

  // Get the list of favorite coins
  List<CryptoCoin> get favoriteCoins => _favoriteCoins;

  // Method to add or remove a coin from favorites
  void toggleFavorite(CryptoCoin coin) {
    if (_favoriteCoins.any((favCoin) => favCoin.id == coin.id)) {
      _favoriteCoins.removeWhere((favCoin) => favCoin.id == coin.id);
    } else {
      _favoriteCoins.add(coin);
    }
    notifyListeners(); // Notify listeners about the change
  }

  // Method to check if a coin is a favorite
  bool isFavorite(CryptoCoin coin) {
    return _favoriteCoins.any((favCoin) => favCoin.id == coin.id);
  }

  // Método para cadastrar um novo usuário com email e senha
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // authStateChanges stream irá notificar os listeners sobre a mudança de estado
      return null; // Retorna null em caso de sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha informada é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'Já existe uma conta com este email.';
      } else {
        return e.message; // Outros erros do Firebase Auth
      }
    } catch (e) {
      return e.toString(); // Erros gerais
    }
  }

  // Método para fazer login com email e senha
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // authStateChanges stream irá notificar os listeners sobre a mudança de estado
      return null; // Retorna null em caso de sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Nenhum usuário encontrado para este email.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta.';
      } else {
        return e.message; // Outros erros do Firebase Auth
      }
    } catch (e) {
      return e.toString(); // Erros gerais
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
    // authStateChanges stream irá notificar os listeners sobre a mudança de estado
    // Clear favorites on logout
    _favoriteCoins.clear();
    notifyListeners(); // Notify listeners that favorites are cleared
  }
}
