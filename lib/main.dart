// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_inicial/home.dart';
import 'package:itafesta/screens/tela_pedidos/pedidos.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';
import './screens/tela_login/login.dart';

class AppStore with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify listeners about the change
  }
}

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppStore()),
    ChangeNotifierProvider(
      create: (context) => CartModel(),
    ),
    ChangeNotifierProvider(create: (context) => ClienteModel()),
  ], child: const RootApp()));
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final List<Widget> _children = [Login(), const HomePage(), OrderScreen()];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    return MaterialApp(
        home: Scaffold(
            body: _children[store.currentIndex],
            bottomNavigationBar: store.currentIndex == 0
                ? null
                : BottomNavigationBar(
                    onTap: (index) {
                      store.updateCurrentIndex(index + 1);
                    },
                    currentIndex: store.currentIndex - 1,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_cart),
                        label: 'Pedidos',
                      ),
                    ],
                  )));
  }
}
