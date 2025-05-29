import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Arquivo gerado pelo flutterfire
import 'controller/auth_controller.dart';
import 'services/coin_service.dart';
import 'view/login_view.dart';
import 'view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Corrigido para usar super.key

  @override
  Widget build(BuildContext context) {
    // Usamos MultiProvider para fornecer várias instâncias
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        Provider<CoinService>(
          create: (_) => CoinService(),
        ),
      ],
      child: MaterialApp(
        title: 'Crypto App',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF1E3A8A), // Deep Blue
          scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Set overall background color
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF1E3A8A), // Deep Blue
            secondary: const Color(0xFFF59E0B), // Amber
            surface: Colors.white, // White for surfaces like Cards
            error: Colors.redAccent,
            onPrimary: Colors.white,
            onSecondary: Colors.black87,
            onSurface: Colors.black87,
            onError: Colors.white,
          ),
          // Definir fonte Roboto (se disponível no dispositivo)
          fontFamily: 'Roboto', // Usará Roboto se estiver disponível
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E3A8A), // Deep Blue
            foregroundColor: Colors.white, // White text/icons
            elevation: 4,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textTheme: ButtonTextTheme.primary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none, // No border line initially
            ),
            filled: true,
            fillColor: Colors.grey[200], // Light grey fill
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          // textTheme: const TextTheme(
          //   bodyMedium: TextStyle(fontSize: 16.0),
          // ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthChecker(), // Widget que verifica o estado de autenticação
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key}); // Corrigido para usar super.key

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // StreamBuilder para reagir às mudanças no estado de autenticação
    return StreamBuilder<User?>(
      stream: authController.userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Se o usuário está logado, mostra a HomeView, senão, mostra a LoginView
        if (snapshot.hasData) {
          return const HomeView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
