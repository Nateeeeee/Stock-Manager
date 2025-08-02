class TemplateContagem {
  final String id;
  final String nome;
  final String descricao;
  final List<ItemTemplate> itens;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  TemplateContagem({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.itens,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  factory TemplateContagem.fromMap(String id, Map<String, dynamic> map) {
    return TemplateContagem(
      id: id,
      nome: map["nome"] ?? "",
      descricao: map["descricao"] ?? "",
      itens: (map["itens"] as List<dynamic>?)
              ?.map((item) => ItemTemplate.fromMap(item))
              .toList() ??
          [],
      criadoEm: DateTime.fromMillisecondsSinceEpoch(map["criadoEm"] ?? 0),
      atualizadoEm: DateTime.fromMillisecondsSinceEpoch(map["atualizadoEm"] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "descricao": descricao,
      "itens": itens.map((item) => item.toMap()).toList(),
      "criadoEm": criadoEm.millisecondsSinceEpoch,
      "atualizadoEm": atualizadoEm.millisecondsSinceEpoch,
    };
  }

  TemplateContagem copyWith({
    String? id,
    String? nome,
    String? descricao,
    List<ItemTemplate>? itens,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return TemplateContagem(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      itens: itens ?? this.itens,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

class ItemTemplate {
  final String nome;
  final List<String> unidades; // Ex: ["Caixas", "Pacotes", "Unidades", "Kg"]
  final String categoria;

  ItemTemplate({
    required this.nome,
    required this.unidades,
    this.categoria = "",
  });

  factory ItemTemplate.fromMap(Map<String, dynamic> map) {
    return ItemTemplate(
      nome: map["produto"] ?? map["nome"] ?? "", // Mapeia \'produto\' ou \'nome\' do Firestore para \'nome\' do modelo
      unidades: List<String>.from(map["categorias"] ?? []), // Mapeia \'categorias\' do Firestore para \'unidades\' do modelo
      categoria: map["categoria"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "unidades": unidades,
      "categoria": categoria,
    };
  }

  ItemTemplate copyWith({
    String? nome,
    List<String>? unidades,
    String? categoria,
  }) {
    return ItemTemplate(
      nome: nome ?? this.nome,
      unidades: unidades ?? this.unidades,
      categoria: categoria ?? this.categoria,
    );
  }
}

