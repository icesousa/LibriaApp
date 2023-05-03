import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libria/src/storage/preferences_manager.dart';

import '../detalhes_page/detalhes_page.dart';
import '../../models/livro.dart';

class ResultadoBuscaPage extends StatefulWidget {
  final List<Livro> lista;
  final String pesquisa;

  const ResultadoBuscaPage(this.lista, this.pesquisa, {Key? key});

  @override
  State<ResultadoBuscaPage> createState() => _ResultadoBuscaPageState();
}

class _ResultadoBuscaPageState extends State<ResultadoBuscaPage> {
  final List<Livro> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
            onTap: () => setState(() {
                  Navigator.pop(context, _favorites);
                }),
            child: Icon(Icons.arrow_back)),
        middle: Text(widget.pesquisa),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2 / 3),
        itemCount: widget.lista.length,
        itemBuilder: (BuildContext context, index) {
          var livro = widget.lista[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => detalhesPage(livro)));
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(livro.thumbnail!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            livro.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'by ${livro.autor!.join(', ')}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (_favorites.contains(livro)) {
                                setState(() {
                                  _favorites.remove(livro);
                                  _favorites.toList();
                                });
                              } else {
                                setState(() {
                                  _favorites.add(livro);
                                  PreferencesManager().adicionarLivros(livro);
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _favorites.contains(livro)
                                        ? Colors.yellow[600]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _favorites.contains(livro)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favorites.contains(livro)
                                        ? Colors.white
                                        : Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
