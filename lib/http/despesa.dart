import 'package:appagro/models/despesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DespesaApi {
  // Função para obter despesas do Firebase
  static Future<List<Despesa>> obterDespesasDaAPI() async {
    List<Despesa> despesas = [];
    // Obtém uma referência para a coleção 'despesas' no Firestore e aguarda o resultado
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('despesas').get();
    // Itera sobre os documentos da coleção
    for (var doc in querySnapshot.docs) {
      // Cria uma nova instância de Despesa com os dados do documento
      var despesa = Despesa(
        documentId: doc.id,
        nome: doc['nome'],
        descricao: doc['descricao'],
        valor: doc['valor'].toDouble(),
        data: doc['data'],
      );
      // Adiciona a despesa à lista
      despesas.add(despesa);
    }
    // Retorna a lista de despesas
    return despesas;
  }

  // Função para adicionar uma nova despesa
  static Future<void> adicionarDespesa(Despesa novaDespesa) async {
    // Adiciona os dados da nova despesa à coleção 'despesas' no Firestore
    await FirebaseFirestore.instance.collection('despesas').add({
      'nome': novaDespesa.nome,
      'descricao': novaDespesa.descricao,
      'valor': novaDespesa.valor,
      'data': novaDespesa.data,
    });
  }

  // Função para excluir uma despesa
  static Future<void> excluirDespesa(String documentId) async {
    // Exclui o documento com o ID correspondente da coleção 'despesas'
    await FirebaseFirestore.instance
        .collection('despesas')
        .doc(documentId)
        .delete();
  }
}