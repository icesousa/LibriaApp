import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

final dataBaseProvider =
    Provider<PreferencesManager>((ref) => PreferencesManager());

class PreferencesManager {
  Future<void> adicionarRecomendado(Livro livro) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(livro.titulo, json.encode(livro.toJson()));
  }

  Future<List<Livro>?> consultarRecomendados() async {
    var lista = <Livro>[];
    final preferences = await SharedPreferences.getInstance();
    final keys = preferences.getKeys();

    for (var id in keys) {
      try {
        final livroJson = json.decode(preferences.getString(id)!);

        lista.add(Livro.fromPreferences(livroJson));
      } catch (e) {
        print('Erro ao desserializar o livro com a chave $id: $e');
      }
    }

    return lista;
  }

  Future<void> adicionarLivros(Livro livro) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(livro.id, json.encode(livro.toJson()));
  }

  Future<List<Livro>?> consultarTodosLivros() async {
    var lista = <Livro>[];
    final preferences = await SharedPreferences.getInstance();
    final keys = preferences.getKeys();

    for (var id in keys) {
      try {
        final livroJson = json.decode(preferences.getString(id)!);

        lista.add(Livro.fromPreferences(livroJson));
      } catch (e) {
        print('Erro ao desserializar o livro com a chave $id: $e');
      }
    }

    return lista;
  }

  Future<void> removerLivros(String id) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(id);
  }

  Future<void> removerTodosLivros() async {
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
