import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastrarTemplatePage extends StatefulWidget {
  const CadastrarTemplatePage({super.key});

  @override
  State<CadastrarTemplatePage> createState() => _CadastrarTemplatePageState();
}

class _CadastrarTemplatePageState extends State<CadastrarTemplatePage> {
  final nomeController = TextEditingController();
  final List<_ProdutoTemp> produtos = [];

  void adicionarProduto() {
    setState(() {
      produtos.add(_ProdutoTemp());
    });
  }

  void removerProduto(int index) {
    setState(() {
      produtos.removeAt(index);
    });
  }

  Future<void> salvarTemplate() async {
    final nome = nomeController.text.trim();
    if (nome.isEmpty || produtos.isEmpty) return;

    final itens = produtos
        .where(
          (p) =>
              p.nome.text.trim().isNotEmpty &&
              p.categoriasSelecionadas.isNotEmpty,
        )
        .map(
          (p) => {
            'produto': p.nome.text.trim(),
            'categorias': p.categoriasSelecionadas,
          },
        )
        .toList();

    if (itens.isEmpty) return;

    await FirebaseFirestore.instance.collection('templates').add({
      'nome': nome,
      'itens': itens,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Template')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Template'),
            ),
            const SizedBox(height: 16),
            ...produtos.asMap().entries.map((entry) {
              final idx = entry.key;
              final produto = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: produto.nome,
                        decoration: InputDecoration(
                          labelText: 'Nome do Produto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['Caixas', 'Pacotes', 'Kg', 'Unidades'].map((
                          cat,
                        ) {
                          final selected = produto.categoriasSelecionadas
                              .contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  produto.categoriasSelecionadas.add(cat);
                                } else {
                                  produto.categoriasSelecionadas.remove(cat);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removerProduto(idx),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Adicionar Produto'),
              onPressed: adicionarProduto,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarTemplate,
              child: Text('Salvar Template'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProdutoTemp {
  final TextEditingController nome = TextEditingController();
  final List<String> categoriasSelecionadas = [];
}
