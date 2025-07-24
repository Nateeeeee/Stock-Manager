import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';

class FirestoreService {
  final _produtos = FirebaseFirestore.instance.collection('produtos');

  Stream<List<Produto>> getProdutos() {
    return _produtos.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Produto.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> adicionarProduto(Produto produto) {
    return _produtos.add(produto.toMap());
  }

  Future<void> atualizarProduto(Produto produto) {
    return _produtos.doc(produto.id).update(produto.toMap());
  }

  Future<void> excluirProduto(String id) {
    return _produtos.doc(id).delete();
  }
}
