import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itafesta/screens/tela_inicial/home.dart';
import 'package:provider/provider.dart';
import '../tela_carrinho/carrinho.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

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
        // atualiza a quantidade do produto no carrinho e atualiza o carrinho
        produtoJaAdicionado.quantity += produto['quantidade'] as int;
        _items[_items
                .indexWhere((item) => item.product['id'] == produto['id'])] =
            produtoJaAdicionado;
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

Future<List<Produto>> fetchProdutosPorFornecedor(int idFornecedor) async {
  final response = await http.get(Uri.parse(
      'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos?fornecedor_id[eq]=$idFornecedor'));

  if (response.statusCode == 200) {
    List<Produto> produtos = [];
    var json = jsonDecode(response.body) as Map<String, dynamic>;

    var data = json['data'] as List<dynamic>;

    for (var produto in data) {
      produtos.add(Produto.fromJson(produto));
    }
    return produtos;
  } else {
    throw Exception('Falha ao carregar produtos');
  }
}

class Produto {
  final int id;
  final String nome;
  final String valor;
  final String descricao;
  final String disponivel;
  final int fornecedorId;
  int quantidade;

  Produto({
    required this.id,
    required this.nome,
    required this.valor,
    required this.descricao,
    required this.disponivel,
    required this.fornecedorId,
    this.quantidade = 0,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      disponivel: json['disponivel'],
      valor: json['valor'],
      fornecedorId: json['fornecedorId'],
      descricao: json['descricao'],
    );
  }
}

class ProdutosPage extends StatefulWidget {
  final Fornecedor fornecedor;
  const ProdutosPage(this.fornecedor, {super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = fetchProdutosPorFornecedor(widget.fornecedor.id);
  }

  IconData getIcon(String tipo) {
    switch (tipo) {
      case 'bolos':
        return Icons.cake_rounded;
      case 'salgados':
        return Icons.bakery_dining_rounded;
      case 'doces':
        return Icons.icecream_rounded;
      case 'bebidas':
        return Icons.wine_bar_rounded;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos', textAlign: TextAlign.center),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: Icon(
                      getIcon(widget.fornecedor.tipo),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fornecedor.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.fornecedor.descricao,
                      ),
                      Text(
                        widget.fornecedor.endereco,
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
                child: FutureBuilder<List<Produto>>(
                    future: futureProdutos,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var produto = snapshot.data![index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 30,
                                  // Substitua a imagem com a foto real do produto
                                  // backgroundImage: AssetImage('caminho/da/imagem.jpg'),
                                ),
                                title: Text(produto.nome),
                                subtitle: Text('R\$ ${produto.valor}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Reduzir a quantidade do produto
                                        setState(() {
                                          if (produto.quantidade <= 0) {
                                            produto.quantidade = 0;
                                          } else {
                                            produto.quantidade -= 1;
                                          }
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Icon(Icons.remove),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      // Aqui deve ser exibida a quantidade do produto
                                      produto.quantidade.toString(),
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
                                          produto.quantidade += 1;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<Produto> produtos = await futureProdutos;

                List<Map<String, dynamic>> formattedProducts =
                    produtos.map((produto) {
                  return {
                    'id': produto.id,
                    'nome': produto.nome,
                    'valor': produto.valor,
                    'descricao': produto.descricao,
                    'disponivel': produto.disponivel,
                    'fornecedorId': produto.fornecedorId,
                    'quantidade': produto.quantidade,
                  };
                }).toList();

                if (!context.mounted) return;
                Provider.of<CartModel>(context, listen: false)
                    .updateCart(formattedProducts);

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
