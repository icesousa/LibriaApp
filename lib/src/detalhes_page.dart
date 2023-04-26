import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'livro.dart';

class detalhesPage extends StatefulWidget {
  const detalhesPage(this.livro, {super.key});
  final Livro livro;

  @override
  State<detalhesPage> createState() => _detalhesPageState();
}

class _detalhesPageState extends State<detalhesPage> {
 late String autor ;
 

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
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.livro.titulo),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.livro.titulo,
                          textAlign: TextAlign.center,
                          maxLines: 20,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 10,),
                  Text(filtrarAutoresPeloPrimeiroNome(widget.livro.autor).join(', '), style: TextStyle(color: Colors.grey.shade600),),
                  SizedBox(
                    height: 16,
                  ),
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
                  SizedBox(
                    height: 16,
                  ),
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
        ));
  }
}
