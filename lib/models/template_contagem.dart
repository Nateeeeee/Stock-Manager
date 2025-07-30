class TemplateContagem {
  final String id;
  final String nome;
  final List<ItemTemplate> itens;

  TemplateContagem({required this.id, required this.nome, required this.itens});

  factory TemplateContagem.fromMap(String id, Map<String, dynamic> map) {
    return TemplateContagem(
      id: id,
      nome: map['nome'],
      itens: (map['itens'] as List)
          .map((e) => ItemTemplate.fromMap(e))
          .toList(),
    );
  }
}

class ItemTemplate {
  final String produto;
  final List<String> categorias;

  ItemTemplate({required this.produto, required this.categorias});

  factory ItemTemplate.fromMap(Map<String, dynamic> map) {
    return ItemTemplate(
      produto: map['produto'],
      categorias: List<String>.from(map['categorias']),
    );
  }
}
