import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libria/src/pages/home_page/home_page.dart';

void main() async {
  runApp(LibriaApp());
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
        
            backgroundColor: CupertinoColors.white,
            inactiveColor: Colors.grey,
            activeColor: Colors.black54,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                  size: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.search,
                  size: 30,
                ),
                label: 'Livros',
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
                builder: (context) => HomePage(),
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
