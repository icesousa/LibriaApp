import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libria/src/storage/preferences_manager.dart';

import '../models/livro.dart';

final favoriteProvider = FutureProvider<List<Livro>?>((ref) async {
  return ref.read(dataBaseProvider).consultarTodosLivros();
});
