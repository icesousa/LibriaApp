import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/livro.dart';

class detalhesPage extends StatefulWidget {
  const detalhesPage(this.livro, {super.key});
  final Livro livro;

  @override
  State<detalhesPage> createState() => _detalhesPageState();
}

class _detalhesPageState extends State<detalhesPage> {
  late String autor;

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white60,
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.livro.titulo),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
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
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 2)
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
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
                              Icon(
                                CupertinoIcons.bookmark,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'by ${filtrarAutoresPeloPrimeiroNome(widget.livro.autor!).join(' ')}',
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
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Pages : ${widget.livro.paginas.toString()}')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
