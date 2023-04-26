import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'livro.dart';
import 'livro_api.dart';
import 'resultado_busca_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _tituloEditingController = TextEditingController();
  Future<List<Livro>?> _futureLivro = Future.value();

  void _pesquisar() async {
    setState(() {
      _futureLivro =
          BooksApi().buscarLivrosPorTitulo(_tituloEditingController.text);

      _futureLivro.then((lista) {
        if (lista != null) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) =>
                  ResultadoBuscaPage(lista, _tituloEditingController.text)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 13,
              ),
              _buildSearchField(),
              SizedBox(
                height: 13,
              ),
              _buildTrendingBooks(),
              _buildGridView(),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói a barra de navegação personalizada
  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      border: null,
      padding: EdgeInsetsDirectional.only(top: 4),
      backgroundColor: CupertinoColors.systemBackground,
      leading: Container(
        width: 70,
        height: 400,
        child: Icon(
          CupertinoIcons.square_grid_3x2,
          size: 39,
          color: CupertinoColors.systemGrey,
        ),
      ),
      middle: Text(
        'Libria',
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
      ),
      trailing: _buildProfileAvatar(),
    );
  }

  // Constrói o avatar do perfil
  Widget _buildProfileAvatar() {
    return Container(
      padding: EdgeInsets.all(5),
      width: 70,
      height: 70,
      child: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?cs=srgb&dl=pexels-pixabay-220453.jpg&fm=jpg',
          )),
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

  Widget _buildTrendingBooks() {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Favorites Books',
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



_buildGridView() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
        6,
        (index) => Card(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: Text('teste'),
            ),
          ),
        ),
      ),
    ),
  );
}





}




