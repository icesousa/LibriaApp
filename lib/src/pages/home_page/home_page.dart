import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libria/src/consts/consts.dart';
import 'package:libria/src/services/web_scraping.dart';
import 'package:libria/src/storage/preferences_manager.dart';
import 'package:libria/src/widgets/container_image.dart';

import '../../models/livro.dart';
import '../../services/livro_api.dart';
import '../detalhes_page/detalhes_page.dart';
import '../resultado_busca_page/resultado_busca_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _tituloEditingController = TextEditingController();
  late OpenAI openAI;
  List<Livro>? recomendados = [];
  List<Livro>? AmazonBooks = [];

  Future<List<Livro>?> _futureLivro = Future.value();

  List<Livro>? _favorites = null;
  bool isReady = false;
  void consultarTodosLivros() async {
    _favorites = await PreferencesManager().consultarTodosLivros();
    setState(() {});
  }

  void _pesquisar() async {
    setState(() {
      print('pesquisando');
      _futureLivro =
          BooksApi().buscarLivrosPorTitulo(_tituloEditingController.text);

      _futureLivro.then((lista) {
        if (lista != null) {
          Navigator.of(context)
              .push(CupertinoPageRoute(
                  builder: (context) => ResultadoBuscaPage(
                        lista,
                        _tituloEditingController.text,
                      )))
              .then((isChanged) {
            if (isChanged == true) {
              setState(() {
                consultarTodosLivros();
              });
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    /*openAI = OpenAI.instance.build(
      token: '',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
    );
    */
    consultarTodosLivros();
  }

  List TitlesFilter(List<Livro>? list) {
    List<dynamic> Stringer = [];
    Stringer.clear();
    if (list != null) {
      for (var livro in list) {
        var favoriteString = 'Titulo: ${livro.titulo} Autor: ${livro.autor}';
        if (!Stringer.contains(favoriteString)) {
          Stringer.add(favoriteString);
        }
      }
      if (list.length == 0) {
        var aviso = 'Nada na lista ainda';
        Stringer.add(aviso);
      }
    }
    print(Stringer);
    return Stringer;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [_buildNavigationBar()],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Let\'s Discover',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ptSerif(
                            textStyle: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 31,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                _buildSearchField(),
                SizedBox(
                  height: 13,
                ),
                _buildSubtitleWidget('Favorites Books'),
                _buildGridView(),
                SizedBox(height: 5),
                SizedBox(
                  height: 10,
                ),
                _buildSubtitleWidget('Based on your favorites'),
                _buildIndicados(),
                SizedBox(
                  height: 15,
                ),
                _buildSubtitleWidget('Based on Amazon\'s bestsellers '),
                _buildAmazon()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Constrói a barra de navegação personalizada
  Widget _buildNavigationBar() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: Text(
              ' Hello, Erysson',
              style: GoogleFonts.ptSerif(
                  color: colorsub1,
                  fontWeight: fontWeightsub1,
                  fontSize: fontSizesub1),
            ),
          )),
          Spacer(),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  // Constrói o campo de busca
  CupertinoTextField _buildSearchField() {
    return CupertinoTextField(
      padding: EdgeInsets.symmetric(vertical: 12.5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: null,
        borderRadius: BorderRadius.circular(6),
      ),
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          CupertinoIcons.search,
          color: Colors.black45,
        ),
      ),
      suffix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: _buildSearchIcon(),
      ),
      placeholder: 'Search',
      clearButtonMode: OverlayVisibilityMode.editing,
      controller: _tituloEditingController,
    );
  }

  // Constrói o botão de busca
  Widget _buildSearchIcon() {
    return FutureBuilder(
        future: _futureLivro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          }
          return GestureDetector(
              onTap: _pesquisar,
              child: Icon(
                CupertinoIcons.arrowtriangle_right,
                color: Colors.black45,
              ));
        });
  }

  Widget _buildSubtitleWidget(String text) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(
            CupertinoIcons.ellipsis,
            color: Colors.black54,
          ),
          SizedBox()
        ],
      ),
    ]);
  }

  Widget _buildGridView() {
    return _favorites != null
        ? _favorites!.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _favorites!.length >= 10 ? 10 : _favorites!.length,
                    (index) {
                      Livro livro = _favorites![index];
                      return customImageContainer(
                          livro.thumbnail!,
                          livro.titulo,
                          livro.autor!.first,
                          context,
                          livro,
                          130,
                          220, () {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(
                                builder: (context) => detalhesPage(
                                      livro,
                                    )))
                            .then((isChanged) {
                          print(isChanged);
                          if (isChanged == true) {
                            consultarTodosLivros();
                          }
                        });
                      });
                    },
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add a book to favorites',
                    style: GoogleFonts.notoSans(
                        color: colorsub1,
                        fontWeight: fontWeightsub1,
                        fontSize: fontSizesub1)),
              )
        : SizedBox();
  }

  void chatComplete() async {
    List<String> GPTAPIList = [];
    setState(() {
      Loading = true;
    });
    /*final request = ChatCompleteText(messages: [
      Map.of({
        "role": "system",
        "content":
            'Você é um sistema de recomendação. Aqui está uma lista de livros favoritos do usuário: ${TitlesFilter(_favorites)} Por favor, responda com o nome e o autor de quatro livros que você recomendaria pro usuario que sejam parecidos ou relacionados com os da lista que recebeu. Envie apenas o nome do livro e o nome do autor, sem mais informações. IMPORTANTE: responda em uma só mensagem com a seguinte organização: Titulo e Autor devem ser separado apenas por espaço, o conjunto separado por virgula. A RESPOSTA NÃO PODE CONTER OS  LIVROS:${TitlesFilter(recomendados)}'
      })
    ], maxToken: 1000, model: ChatModel.gptTurbo);
*/
    //  final response = await openAI.onChatCompletion(request: request);
    List<String> responseMock = [
      "O Morro dos Ventos Uivantes Emily Bronte, O Retrato de Dorian Gray Oscar Wilde, A Insustentável Leveza do Ser Milan Kundera, A Revolução dos Bichos George Orwell."
    ];

    // print(' quantidade : ${response!.choices.length}');

    // for (var element in response!.choices) {
    for (var element in responseMock) {
      //   print("data -> ${element.message?.content}");
      print("data -> ${element}");
      GPTAPIList.addAll(element.split(','));
    }
    for (String livro in GPTAPIList) {
      var _recomendLivro = BooksApi().buscarLivrosPorTitulo('$livro');

      _recomendLivro.then((lista) {
        if (lista != null) {
          setState(() {
            var filtrado = lista.firstWhere((element) =>
                element.thumbnail != null &&
                Uri.parse(element.thumbnail!).isAbsolute);
            recomendados!.add(filtrado);

            print('adicionado ${lista.first.titulo}');
          });
        }
      });
    }
    setState(() {
      Loading = false;
    });
  }

  bool Loading = false;
  _buildIndicados() {
    Widget isLoading(bool isLoading) {
      if (_favorites != null) {
        if (_favorites!.length < 5) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'At least 5 favorites required (${5 - _favorites!.length} missing)',
              style: GoogleFonts.notoSans(
                  fontSize: fontSizesub1,
                  color: colorsub1,
                  fontWeight: fontWeightsub1),
            ),
          );
        }
      }
      if (isLoading == true) {
        return CupertinoActivityIndicator();
      }
      if (recomendados!.length > 0) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              recomendados!.length,
              (index) {
                Livro livro = recomendados![index];
                return customImageContainer(livro.thumbnail!, livro.titulo,
                    livro.autor!.first, context, livro, 130, 220, () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(
                          builder: (context) => detalhesPage(
                                livro,
                              )))
                      .then((isChanged) {
                    if (isChanged == true) {
                      consultarTodosLivros();
                    }
                  });
                });
              },
            ),
          ),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                  onPressed: chatComplete,
                  child: Text(
                    'Click to load recommendations',
                    style: GoogleFonts.notoSans(
                        color: colorsub1,
                        fontWeight: fontWeightsub1,
                        fontSize: fontSizesub1),
                  )),
            ),
          ],
        );
      }
    }

    return isLoading(Loading);
  }

  bool isAmazonLoading = false;
  _buildAmazon() {
    Widget isLoading(bool isLoading) {
      if (isAmazonLoading == true) {
        return CupertinoActivityIndicator();
      }

      if (AmazonBooks != null) {
        if (AmazonBooks!.length > 0) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                AmazonBooks!.length,
                (index) {
                  Livro livro = AmazonBooks![index];
                  return customImageContainer(livro.thumbnail!, livro.titulo,
                      livro.autor!.first, context, livro, 130, 220, () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(
                            builder: (context) => detalhesPage(
                                  livro,
                                )))
                        .then((isChanged) {
                      if (isChanged == true) {
                        consultarTodosLivros();
                      }
                    });
                  });
                },
              ),
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                    onPressed: () async {
                      setState(() {
                        isAmazonLoading = true;
                      });
                      AmazonBooks = await getAmazonBooks();

                      setState(() {
                        isAmazonLoading = false;
                      });
                      setState(() {});
                    },
                    child: Text(
                      'Click to load Amazon',
                      style: GoogleFonts.notoSans(
                          color: colorsub1,
                          fontWeight: fontWeightsub1,
                          fontSize: fontSizesub1),
                    )),
              ),
            ],
          );
        }
      } else {
        return Text('nothing to show');
      }
    }

    return isLoading(isAmazonLoading);
  }
}
