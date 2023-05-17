import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/livro.dart';
import '../../storage/preferences_manager.dart';

class detalhesPage extends StatefulWidget {
  const detalhesPage(this.livro, {super.key});
  final Livro livro;

  @override
  State<detalhesPage> createState() => _detalhesPageState();
}

class _detalhesPageState extends State<detalhesPage> {
  late String autor;
  List<Livro>? _favorites;
  bool isChanged = false;

  List<String> filtrarAutoresPeloPrimeiroNome(List<dynamic> autores) {
    Set<String> primeirosNomesUnicos = {};
    List<String> autoresFiltrados = [];

    for (String autor in autores) {
      String primeiroNome = autor.split(' ')[0];
      if (!primeirosNomesUnicos.contains(primeiroNome)) {
        primeirosNomesUnicos.add(primeiroNome);
        autoresFiltrados.add(autor);
      }
    }

    return autoresFiltrados;
  }

  void consultarTodosLivros() async {
    print('consultando');
    _favorites = await PreferencesManager().consultarTodosLivros();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _favorites == null ? consultarTodosLivros() : null;
    var isFavorite =
        _favorites?.any((element) => element.titulo == widget.livro.titulo) ??
            false;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white60,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
            onTap: () => setState(() {
                  Navigator.pop(context, isChanged);
                }),
            child: Icon(Icons.arrow_back)),
        middle: Text(widget.livro.titulo),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 240,
                      height: 300,
                      child: Image.network(
                        widget.livro.thumbnail!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.6),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.grey.shade200],
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, left: 6.0, right: 6.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.livro.titulo,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isChanged = true;
                                      if (isFavorite == true) {
                                        print('remover');
                                        PreferencesManager()
                                            .removerLivros(widget.livro.id);
                                      } else {
                                        print('adicionar');
                                        PreferencesManager()
                                            .adicionarLivros(widget.livro);
                                      }
                                      consultarTodosLivros();
                                    });
                                  },
                                  child: Icon(
                                    isFavorite
                                        ? CupertinoIcons.bookmark_fill
                                        : CupertinoIcons.bookmark,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.livro.paginas.toString()} Pages',
                                  style: TextStyle(color: Colors.grey.shade800),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'by ${filtrarAutoresPeloPrimeiroNome(widget.livro.autor!).join(', ')}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.livro.descricao!,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.fade,
                                    maxLines: null,
                                    softWrap: true,
                                  ),
                                )
                              ],
                            ),
                           
                           
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
