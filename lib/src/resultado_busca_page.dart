import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detalhes_page.dart';
import 'livro.dart';

class ResultadoBuscaPage extends StatefulWidget {
  final List<Livro> lista;
  final String pesquisa;
  ResultadoBuscaPage(this.lista, this.pesquisa, {super.key});

  @override
  State<ResultadoBuscaPage> createState() => _ResultadoBuscaPageState();
}

class _ResultadoBuscaPageState extends State<ResultadoBuscaPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.pesquisa),
        ),
        child: ListView.separated(
          itemCount: widget.lista.length,
          separatorBuilder: (BuildContext context, index) => Divider(
            thickness: 1,
            color: Colors.white,),
          itemBuilder: (BuildContext context, index) {
            var livro = widget.lista[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => detalhesPage(livro)));
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 17),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      livro.thumbnail!,
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.contain,
                                    ),
                                  
                                  ],
                                ),
                                SizedBox(height: 11,),
                                  Icon(
                                      CupertinoIcons.star_fill,
                                      color: Colors.amber,
                                    ),
                                SizedBox(height: 17),
                                Expanded(
                                  child: Text(
                                    livro.titulo,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(height: 17)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
