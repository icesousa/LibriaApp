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
            'https://cdn2.hubspot.net/hubfs/242200/shutterstock_774749455.jpg',
        autor = json['volumeInfo']['authors'] ?? 'Autor não Encontrado';

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
        descricao = json['descricao']?? 'Description not found',
        paginas = json['paginas']?? 00,
        thumbnail = json['thumbnail']?? 'https://cdn2.hubspot.net/hubfs/242200/shutterstock_774749455.jpg',
        autor = json['autor']?? 'Author not found';

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
}
