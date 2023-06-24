import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/http/http.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class SearchMovies implements LoadMovies {
  final String token;
  final HttpClient httpClient;

  const SearchMovies({
    required this.httpClient,
    required this.token,
  });
  @override
  Future<List<MovieEntity>> call(String url) async {
    await httpClient.request(
      url: url,
      method: 'GET',
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return Future.value([]);
  }
}

void main() {
  late HttpClientSpy httpClientSpy;
  late String url;
  late String token;
  late SearchMovies sut;

  setUp(() {
    httpClientSpy = HttpClientSpy();
    url = faker.internet.httpUrl();
    token = faker.jwt.valid();
    sut = SearchMovies(httpClient: httpClientSpy, token: token);
  });

  test('Should call httpClient with correct values', () async {
    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => _);

    await sut(url);

    verify(
      () => httpClientSpy.request(
        url: url,
        method: 'GET',
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    ).called(1);
  });
}
