import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import 'login_view.dart';
import 'coins_list_view.dart';
import 'favorites_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CoinsListView(),
    FavoritesListView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              // Schedule navigation after the current frame to avoid BuildContext across async gaps warning
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Verify if the widget is still mounted before navigating
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary, // Usando a cor de acento do tema
        unselectedItemColor: Colors.grey[600], // Cor para itens não selecionados
        onTap: _onItemTapped,
        elevation: 8.0, // Adicionando elevação
      ),
    );
  }
}
