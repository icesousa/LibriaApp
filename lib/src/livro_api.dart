import 'dart:convert';

import 'livro.dart';
import 'package:http/http.dart' as Http;

const URL = "https://www.googleapis.com/books/v1/volumes?q=";

class BooksApi {
  Future<List<Livro>?> buscarLivrosPorTitulo(String titulo) async {
    var url = URL + titulo;
    final response = await Http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //sucess
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      var totalItems = jsonResponse["totalItems"] as int;
      if (totalItems == 0) {
        return null;
      }
      var listaItems = jsonResponse['items'] as List;

      return listaItems.map((livro) => Livro.fromJson(livro)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
