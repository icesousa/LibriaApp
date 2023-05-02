import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libria/src/pages/home_page/home_page.dart';
import 'package:libria/src/pages/pesquisar_page/pesquisar_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
await  Hive.initFlutter();
  
  await Hive.openBox('favoritesBooks');
  await Hive.box('favoritesBooks');

  runApp(
       LibriaApp());
}

class LibriaApp extends StatelessWidget {
  const LibriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            inactiveColor: Colors.white60,
            activeColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.search,
                ),
                label: 'Pesquisar',
              )
            ]),
        tabBuilder: (context, index) {
          late CupertinoTabView retorno;
          switch (index) {
            case 0:
              retorno = CupertinoTabView(
                builder: (context) => HomePage(),
              );
              break;
            case 1:
              retorno = CupertinoTabView(
                builder: (context) => PesquisarPage(),
              );
              break;
            default:
          }
          return retorno;
        },
      ),
    );
  }
}
