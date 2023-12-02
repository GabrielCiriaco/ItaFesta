// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';
import './screens/tela_login/login.dart';

void main() {
  runApp(MultiProvider(providers: [
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),

      routes: {
        // '/extrato':(_) => Extrato(),
        // '/meu-fluxo':(_) => TiposMov(),
        // '/metas':(_) => Metas(),
        // '/creditos':(_) => Creditos(),
        // '/newMov':(_)=> NewMov(),
      },
    );
  }
}
