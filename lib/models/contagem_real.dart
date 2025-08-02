class ContagemReal {
  final String id;
  final String templateId;
  final String nomeTemplate;
  final List<ItemContado> itensContados;
  final DateTime dataContagem;
  final String observacoes;
  final String responsavel;

  ContagemReal({
    required this.id,
    required this.templateId,
    required this.nomeTemplate,
    required this.itensContados,
    required this.dataContagem,
    this.observacoes = "",
    this.responsavel = "",
  });

  factory ContagemReal.fromMap(Map<String, dynamic> map) {
    return ContagemReal(
      id: map["id"] ?? "",
      templateId: map["templateId"] ?? "",
      nomeTemplate: map["nomeTemplate"] ?? "",
      itensContados: (map["itensContados"] as List<dynamic>?)
              ?.map((item) => ItemContado.fromMap(item))
              .toList() ??
          [],
      dataContagem: DateTime.fromMillisecondsSinceEpoch(map["dataContagem"] ?? 0),
      observacoes: map["observacoes"] ?? "",
      responsavel: map["responsavel"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "templateId": templateId,
      "nomeTemplate": nomeTemplate,
      "itensContados": itensContados.map((item) => item.toMap()).toList(),
      "dataContagem": dataContagem.millisecondsSinceEpoch,
      "observacoes": observacoes,
      "responsavel": responsavel,
    };
  }

  ContagemReal copyWith({
    String? id,
    String? templateId,
    String? nomeTemplate,
    List<ItemContado>? itensContados,
    DateTime? dataContagem,
    String? observacoes,
    String? responsavel,
  }) {
    return ContagemReal(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      nomeTemplate: nomeTemplate ?? this.nomeTemplate,
      itensContados: itensContados ?? this.itensContados,
      dataContagem: dataContagem ?? this.dataContagem,
      observacoes: observacoes ?? this.observacoes,
      responsavel: responsavel ?? this.responsavel,
    );
  }
}

class ItemContado {
  final String nomeItem;
  final Map<String, double> quantidades; // Ex: {"Caixas": 5.0, "Pacotes": 12.0, "Unidades": 240.0}
  final String categoria;

  ItemContado({
    required this.nomeItem,
    required this.quantidades,
    this.categoria = "",
  });

  factory ItemContado.fromMap(Map<String, dynamic> map) {
    return ItemContado(
      nomeItem: map["nomeItem"] ?? "",
      quantidades: Map<String, double>.from(map["quantidades"] ?? {}),
      categoria: map["categoria"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nomeItem": nomeItem,
      "quantidades": quantidades,
      "categoria": categoria,
    };
  }

  ItemContado copyWith({
    String? nomeItem,
    Map<String, double>? quantidades,
    String? categoria,
  }) {
    return ItemContado(
      nomeItem: nomeItem ?? this.nomeItem,
      quantidades: quantidades ?? this.quantidades,
      categoria: categoria ?? this.categoria,
    );
  }

  // Método para obter o total de uma unidade específica
  double getQuantidade(String unidade) {
    return quantidades[unidade] ?? 0.0;
  }

  // Método para atualizar a quantidade de uma unidade específica
  ItemContado setQuantidade(String unidade, double valor) {
    final novasQuantidades = Map<String, double>.from(quantidades);
    novasQuantidades[unidade] = valor;
    return copyWith(quantidades: novasQuantidades);
  }
}

