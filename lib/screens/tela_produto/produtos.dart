import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_inicial/home.dart';
import 'package:provider/provider.dart';
import '../tela_carrinho/carrinho.dart';

class CartItem {
  final Map<String, dynamic> product;
  num quantity;

  CartItem(this.product, this.quantity);
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void updateCart(List<Map<String, dynamic>> produtos) {
    // Adiciona os produtos com quantidade maior que 0 ao carrinho, caso ja exista, soma a quantidade
    var produtosParaAdicionar =
        produtos.where((element) => element['quantidade'] > 0).toList();

    if (items.isEmpty) {
      for (var produto in produtosParaAdicionar) {
        _items.add(CartItem(produto, produto['quantidade']));
      }
      notifyListeners();
      return;
    }

    for (var produto in produtosParaAdicionar) {
      var produtoJaAdicionado = items.firstWhere(
          (element) => element.product['id'] == produto['id'],
          orElse: () => CartItem({}, 0));

      if (produtoJaAdicionado.product['id'] != null) {
        produtoJaAdicionado.quantity += produto['quantidade'];
        continue;
      }

      _items.add(CartItem(produto, produto['quantidade']));
    }

    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  void removeItem(CartItem item) {
    _items.remove(item);

    notifyListeners();
  }
}

class ProdutosPage extends StatefulWidget {
  final Fornecedor fornecedor;
  const ProdutosPage(this.fornecedor, {super.key});

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
      'id_fornecedor': 1,
      'quantidade': 0
    },
    {
      'id': 2,
      'nome': 'Bolo de Morango',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1,
      'quantidade': 0
    },
    {
      'id': 3,
      'nome': 'Bolo de Cenoura',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1,
      'quantidade': 0
    },
    {
      'id': 4,
      'nome': 'Bolo de Laranja',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1,
      'quantidade': 0
    },
    {
      'id': 5,
      'nome': 'Bolo de Limão',
      'disponivel': true,
      'valor': '30,99',
      'id_fornecedor': 1,
      'quantidade': 0
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarrinhoPage()),
              );
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
                        widget.fornecedor.nome ?? 'Nome não disponível',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.fornecedor.descricao ??
                            'Descrição não disponível',
                      ),
                      Text(
                        widget.fornecedor.descricao ??
                            'Endereço não disponível',
                        style: const TextStyle(
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
                      leading: const CircleAvatar(
                        radius: 30,
                        // Substitua a imagem com a foto real do produto
                        // backgroundImage: AssetImage('caminho/da/imagem.jpg'),
                      ),
                      title: Text(produto['nome']),
                      subtitle: Text('R\$ ${produto['valor']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Reduzir a quantidade do produto
                              setState(() {
                                if (produto['quantidade'] == null ||
                                    produto['quantidade'] <= 0) {
                                  produto['quantidade'] = 0;
                                } else {
                                  produto['quantidade'] -= 1;
                                }
                              });
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
                          Text(
                            // Aqui deve ser exibida a quantidade do produto
                            produto['quantidade'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Aumentar a quantidade do produto
                              setState(() {
                                if (produto['quantidade'] == null) {
                                  produto['quantidade'] = 1;
                                }
                                produto['quantidade'] += 1;
                              });
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
                Provider.of<CartModel>(context, listen: false)
                    .updateCart(produtos);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarrinhoPage()),
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
