import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

class PreferencesManager {
  Future<void> adicionarLivros(Livro livro) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(livro.id, json.encode(livro.toJson()));
    print(livro.titulo);
    print(preferences.getKeys().toString());
  }

  Future<List<Livro>?> consultarTodosLivros() async {
    var lista = <Livro>[];
    final preferences = await SharedPreferences.getInstance();
    final keys = preferences.getKeys();
    print(keys.toString());

    for (var id in keys) {
      try {
        final livroJson = json.decode(preferences.getString(id)!);
        print('Dados JSON do livro com a chave $id: $livroJson'); // Imprime o conteúdo de livroJson
        lista.add(Livro.fromPreferences(livroJson));
        print(lista);
      } catch (e) {
        print('Erro ao desserializar o livro com a chave $id: $e');
      }
    }

    print('Lista de livros retornada: $lista');
    return lista;
  }

  Future<void> removerLivros(String id) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(id);
  }

  Future<void> removerTodosLivros( )async{
    final preferences = await SharedPreferences.getInstance();
    var collection = preferences.getKeys();
    for (var livro in collection) {
      preferences.remove(livro);
    }
  }

  Future<bool> ToogleFavorite(String id) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey(id);
  }
}
