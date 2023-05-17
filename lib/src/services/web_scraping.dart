import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import '../models/livro.dart';
import 'livro_api.dart';

Future<List<Livro>?> getAmazonBooks() async {
  List<Livro>? AmazonBooks = [];

  var client = Client();
  Response response;

  try {
    response = await client.get(
      Uri.parse('https://www.amazon.com.br/gp/bestsellers/books/'),
    );
  } catch (e) {
    throw Exception('Failed to connect: $e');
  }

  if (response.body.isEmpty) {
    throw Exception('Empty response received');
  }

  var document = parse(response.body);

  List<Element> items;
  try {
    items = document.querySelectorAll('#gridItemRoot');
  } catch (e) {
    throw Exception('Failed to parse document: $e');
  }

  List<Map<String, dynamic>> books = []; // List to hold book maps

  var limitedItems = items.take(5);
  for (var element in limitedItems) {
    try {
      var titleElement =
          element.querySelector('div._cDEzb_p13n-sc-css-line-clamp-1_1Fn1y');

      var authorElement =
          element.querySelector('a.a-size-small.a-link-child') ??
              element.querySelector('span.a-size-small.a-color-base');

      if (titleElement == null || authorElement == null) {
        throw Exception('Failed to select title or author element');
      }

      var bookMap = {'titulo': titleElement.text, 'autor': authorElement.text};
      books.add(bookMap);

      print('TITULO: ${titleElement.text}    AUTOR: ${authorElement.text}');
    } catch (e) {
      print('Failed to process item: $e');
    }
  }
  for (var book in books) {
    print('Book: ${book['titulo']}    Author: ${book['autor']}');
    var _amazonBooks = BooksApi().buscarLivrosPorTitulo('${book['titulo']}');

    _amazonBooks.then((livrosAmazon) {
      if (livrosAmazon != null) {
        var filtrado = livrosAmazon.firstWhere((element) =>
            element.thumbnail != null &&
            Uri.parse(element.thumbnail!).isAbsolute);
        AmazonBooks.add(filtrado);
        print("adicionado ${filtrado.titulo}");
      } else {
        throw {print('erro encontrado, provavel nulo')};
      }
    });
  }
  return AmazonBooks;
}
