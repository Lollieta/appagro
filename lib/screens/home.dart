import 'package:appagro/http/despesa.dart';
import 'package:appagro/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appagro/models/despesa.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Despesa> despesas = [];

  @override
  void initState() {
    super.initState();
    atualizarDespesas();
  }

  // Função para atualizar a lista de despesas
  void atualizarDespesas() async {
    List<Despesa> listaDespesas = await DespesaApi.obterDespesasDaAPI();
    setState(() {
      despesas = listaDespesas;
    });
  }

  // Função para mostrar o formulário de nova despesa
  Future<void> mostrarFormularioNovaDespesa(BuildContext context) async {
    String nome = '';
    String descricao = '';
    double valor = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova Despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => nome = value,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                onChanged: (value) => descricao = value,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                onChanged: (value) =>
                    valor = double.parse(value.replaceAll(',', '.')),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Despesa novaDespesa = Despesa(
                  documentId: '',
                  nome: nome,
                  descricao: descricao,
                  valor: valor,
                  data: DateTime.now().toString(),
                );
                await DespesaApi.adicionarDespesa(novaDespesa);
                atualizarDespesas();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  // Função para excluir uma despesa
  Future<void> excluirDespesa(String documentId) async {
    await DespesaApi.excluirDespesa(documentId);
    atualizarDespesas();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Controle de Custos Agrícolas'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: despesas.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(despesas[index].nome),
              subtitle: Text(
                  'Descrição: ${despesas[index].descricao}\nValor: ${despesas[index].valor.toStringAsFixed(2)}\nData: ${despesas[index].data}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => excluirDespesa(despesas[index].documentId),
                color: Colors.red,
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => mostrarFormularioNovaDespesa(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}