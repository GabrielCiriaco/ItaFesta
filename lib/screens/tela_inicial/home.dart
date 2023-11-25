import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../tela_produto/produtos.dart';


abstract class IFornecedor {
  int get id;
  String get tipo;
  String get nome;
  String get descricao;
  String get endereco;
  String get telefone;
}

class HomePage extends StatelessWidget {

 final List <Map<String, dynamic>>fornecedores = [
    {
      'id': 1,
      'tipo': 'bolos',
      'nome': 'João Bolos',
      'descricao': 'Os melhores bolos doces de Itajubá',
      'endereco': 'Rua dos Bolos, 123',
      'telefone': '123456789'
    },
    {
      'id': 2,
      'tipo': 'salgados',
      'nome': 'Maria Salgados',
      'descricao': 'Os melhores salgados de Itajubá',
      'endereco': 'Rua dos Salgados, 123',
      'telefone': '123456789'
    },
    {
      'id': 3,
      'tipo': 'doces',
      'nome': 'José Doces',
      'descricao': 'Os melhores doces de Itajubá',
      'endereco': 'Rua dos Doces, 123',
      'telefone': '123456789'
    },
    {
      'id': 4,
      'tipo': 'bebidas',
      'nome': 'Joana Bebidas',
      'descricao': 'As melhores bebidas de Itajubá',
      'endereco': 'Rua das Bebidas, 123',
      'telefone': '123456789'
    },
    // Adicione outros fornecedores aqui
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Inicio', textAlign: TextAlign.center),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Adicione a função para abrir o carrinho de compras
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        
                      },
                      child: Card(
                        child: SizedBox(
                          height: 70,
                          child: Center(child: Text('Bolos'))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navegar para a tela de salgados
                      },
                      child: Card(
                        child: SizedBox(
                          height: 70,
                          child: Center(child: Text('Salgados'))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navegar para a tela de doces
                      },
                      child: Card(
                        child: SizedBox(
                          height: 70,
                          child: Center(child: Text('Doces'))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navegar para a tela de bebidas
                      },
                      child: Card(
                        child: SizedBox(
                          height: 70,
                          child: Center(child: Text('Bebidas'))),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: Text(
                        'Mais Populares',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              
             ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: fornecedores.length,
        itemBuilder: (context, index) {
  var fornecedor = fornecedores[index];
  return GestureDetector(
    onTap: () {
      // Adicione a lógica para navegar para a página do fornecedor
      // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesFornecedor(fornecedor)));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProdutosPage(fornecedores[index])),
      );
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.cake, // Ícone que representa o fornecedor
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fornecedor['nome']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text('${fornecedor['descricao']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
},
      ),
            ],
          ),
        ),
      );
  }
}

class CardWithStore extends StatelessWidget {
  final String storeName;
  final String storeDescription;
  final IconData icon;

  const CardWithStore({
    required this.storeName,
    required this.storeDescription,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(storeDescription),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  
