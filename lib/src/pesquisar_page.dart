import 'package:flutter/cupertino.dart';
import 'package:libria/src/livro.dart';
import 'package:libria/src/livro_api.dart';
import 'package:libria/src/resultado_busca_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PesquisarPage extends StatefulWidget {
  const PesquisarPage({super.key});

  @override
  State<PesquisarPage> createState() => _PesquisarPageState();
}

class _PesquisarPageState extends State<PesquisarPage> {
  late Livro teste;
  TextEditingController _TituloeditingController = TextEditingController();
  Future<List<Livro>?> _futurelivro = Future.value();


  void _pesquisar() async {
    setState(() {
      _futurelivro =
          BooksApi().buscarLivrosPorTitulo(_TituloeditingController.text);
          

      _futurelivro.then((lista) {
        if (lista != null) {
          
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => ResultadoBuscaPage(lista, _TituloeditingController.text)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ListView(
          children: [
            CupertinoTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 8,
              ),
              placeholder: 'Titulo',
              clearButtonMode: OverlayVisibilityMode.editing,
              controller: _TituloeditingController,
            ),
            SizedBox(height: 16),
            FutureBuilder(
                future: _futurelivro,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoButton.filled(
                        child: CupertinoActivityIndicator(), onPressed: null);
                  }
                  return CupertinoButton.filled(
                      child: Text('Pesquisar'), onPressed: _pesquisar);
                })
          ],
        ),
      ),
    );
  }
}
