// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_produto/produtos.dart';
import 'package:provider/provider.dart';
import './screens/tela_login/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: rootApp(),
    ),
  );
}

class rootApp extends StatefulWidget {
  @override
  State<rootApp> createState() => _rootAppState();
}

class _rootAppState extends State<rootApp> {
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
