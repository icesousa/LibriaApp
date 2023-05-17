class Livro {
  final String id;
  final String titulo;
  String? descricao;
  int? paginas;
  String? thumbnail;
  List<dynamic>? autor;

  Livro(
    this.id,
    this.titulo,
    this.descricao,
    this.paginas,
    this.thumbnail,
    this.autor,
  );

  Livro.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        titulo = json['volumeInfo']['title'],
        descricao = json['volumeInfo']['description'] ?? 'Not found',
        paginas = json['volumeInfo']['pageCount'] ?? 0,
        thumbnail = json['volumeInfo']['imageLinks']?['thumbnail'] ??
            'imagens/notfound.png',
        autor = json['volumeInfo']['authors'] is String
            ? [json['volumeInfo']['authors']]
            : json['volumeInfo']['authors'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'paginas': paginas,
      'thumbnail': thumbnail,
      'autor': autor,
    };
  }

  Livro.fromPreferences(Map<String, dynamic> json)
      : id = json["id"],
        titulo = json['titulo'],
        descricao = json['descricao'] ?? 'Description not found',
        paginas = json['paginas'] ?? 00,
        thumbnail = json['thumbnail'] ??
            'imagens/notfound.png',
        autor = json['autor'] ?? 'Author not found';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'paginas': paginas,
      'thumbnail': thumbnail,
      'autor': autor,
    };
  }

  static Livro fromMap(Map<dynamic, dynamic> map) {
    return Livro(map['id'], map['titulo'], map['descricao'], map['paginas'],
        map['thumbnail'], map['autor']);
  }

  String toString1() {
    return 'Titulo: $titulo, Autor: $autor, id: $id';
  }
}
