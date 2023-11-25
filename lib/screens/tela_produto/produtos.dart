import 'package:flutter/material.dart';
import '../tela_carrinho/carrinho.dart';

class ProdutosPage extends StatefulWidget {
  final Map<String, dynamic> fornecedor;
  ProdutosPage(this.fornecedor);

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final List<Map<String, dynamic>> produtos = [
    {
      'id': 1,
      'nome': 'Bolo de Chocolate',
      'disponivel': false,
      'valor': '30,99',
      'id_fornecedor': 1
    },
    {
      'id': 2,
      'nome': 'Bolo de Morango',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1
    },
    {
      'id': 3,
      'nome': 'Bolo de Cenoura',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1
    },
    {
      'id': 4,
      'nome': 'Bolo de Laranja',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1
    },
    {
      'id': 5,
      'nome': 'Bolo de Limão',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doces', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Função para abrir o carrinho de compras
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: Icon(Icons.cake, size: 30, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fornecedor['nome'] ?? 'Nome não disponível',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.fornecedor['descricao'] ?? 'Descrição não disponível',
                      ),
                      Text(
                        widget.fornecedor['endereco'] ?? 'Endereço não disponível',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Produtos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  var produto = produtos[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        // Substitua a imagem com a foto real do produto
                        backgroundImage: AssetImage('caminho/da/imagem.jpg'),
                      ),
                      title: Text(produto['nome']),
                      subtitle: Text('R\$ ${produto['valor']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Reduzir a quantidade do produto
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '1', // Aqui deve ser exibida a quantidade do produto
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Aumentar a quantidade do produto
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarrinhoPage()),
                );
              },
              child: const Text('Colocar no Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
