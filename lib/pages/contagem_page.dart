import 'package:flutter/material.dart';
import '../models/template_contagem.dart';
import '../services/local_storage_service.dart';

class ContagemPage extends StatefulWidget {
  final String templateId;
  final String templateNome;
  final List<ItemTemplate> itens;
  final Map<String, Map<String, int>>? contagemInicial;

  const ContagemPage({
    required this.templateId,
    required this.templateNome,
    required this.itens,
    this.contagemInicial,
    super.key,
  });

  @override
  State<ContagemPage> createState() => _ContagemPageState();
}

class _ContagemPageState extends State<ContagemPage> {
  late Map<String, Map<String, int>> contagem;

  @override
  void initState() {
    super.initState();
    if (widget.contagemInicial != null) {
      contagem = {
        for (var item in widget.itens)
          item.produto: {
            for (var cat in item.categorias)
              cat: widget.contagemInicial![item.produto]?[cat] ?? 0,
          },
      };
    } else {
      contagem = {
        for (var item in widget.itens)
          item.produto: {for (var cat in item.categorias) cat: 0},
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contagem - ${widget.templateNome}')),
      body: ListView(
        children: widget.itens.map((item) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.produto,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...item.categorias.map(
                  (cat) => ListTile(
                    title: Text(cat),
                    trailing: SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: contagem[item.produto]![cat].toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            contagem[item.produto]![cat] =
                                int.tryParse(val) ?? 0;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          await salvarContagemLocal(
            templateId: widget.templateId,
            templateNome: widget.templateNome,
            contagem: contagem,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Contagem salva localmente!')));
        },
      ),
    );
  }
}
