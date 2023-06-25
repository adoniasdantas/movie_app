import 'package:localstorage/localstorage.dart';
import 'package:movie_app/infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  final localStorage = LocalStorage('movie-db');
  return LocalStorageAdapter(localStorage: localStorage);
}
