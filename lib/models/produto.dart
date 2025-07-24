class Produto {
  final String id;
  final String nome;
  final Map<String, int>
  quantidades; // Ex: {'Caixas': 2, 'Pacotes': 5, 'Unidades': 0}

  Produto({required this.id, required this.nome, required this.quantidades});

  factory Produto.fromMap(String id, Map<String, dynamic> map) {
    return Produto(
      id: id,
      nome: map['nome'],
      quantidades: Map<String, int>.from(
        map['quantidades'] ?? {'Caixas': 0, 'Pacotes': 0, 'Unidades': 0},
      ),
    );
  }

  Map<String, dynamic> toMap() => {'nome': nome, 'quantidades': quantidades};
}
