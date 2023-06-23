import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';

import 'package:movie_app/domain/usecases/load_movies.dart';

class LoadTrendingMovies implements LoadMovies {
  final String token;
  final HttpClient httpClient;

  const LoadTrendingMovies({
    required this.httpClient,
    required this.token,
  });

  @override
  Future<List<MovieEntity>> call(String url) async {
    final data = await httpClient.request(url: url, method: 'GET', headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    return Future.value([]);
  }
}

abstract class ApiKey {
  String get apiKey;
}

abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required String method,
    Map headers,
  });
}

class ApiKeySpy extends Mock implements ApiKey {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call httpClient with correct values', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final token = faker.jwt.valid();
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        headers: any(named: 'headers'))).thenAnswer((_) async => _);

    final sut = LoadTrendingMovies(httpClient: httpClient, token: token);

    await sut(url);

    verify(() => httpClient.request(
          url: url,
          method: 'GET',
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        )).called(1);
  });
}
