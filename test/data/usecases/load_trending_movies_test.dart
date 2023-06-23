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
    return (data['results'] as List)
        .map((movieJson) => MovieEntity.fromJson(movieJson))
        .toList();
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
  late HttpClientSpy httpClientSpy;
  late String url;
  late String token;
  late LoadTrendingMovies sut;

  setUp(() {
    httpClientSpy = HttpClientSpy();
    url = faker.internet.httpUrl();
    token = faker.jwt.valid();
    when(() =>
        httpClientSpy.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'))).thenAnswer((_) async => {
          'results': [
            {
              "id": faker.randomGenerator.integer(100),
              "title": faker.lorem.sentence(),
              "overview": faker.lorem.sentence(),
              "averageGrade": faker.randomGenerator.decimal(scale: 2, min: 0),
              "releaseDate": faker.date.dateTime(),
              "posterPath": faker.internet.httpUrl(),
            },
            {
              "id": faker.randomGenerator.integer(100),
              "title": faker.lorem.sentence(),
              "overview": faker.lorem.sentence(),
              "averageGrade": faker.randomGenerator.decimal(scale: 2, min: 0),
              "releaseDate": faker.date.dateTime(),
              "posterPath": faker.internet.httpUrl(),
            },
          ]
        });
    sut = LoadTrendingMovies(httpClient: httpClientSpy, token: token);
  });

  test('Should call httpClient with correct values', () async {
    await sut(url);

    verify(() => httpClientSpy.request(
          url: url,
          method: 'GET',
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        )).called(1);
  });

  test('Should return a list of MovieEntity', () async {
    final result = await sut(url);

    expect(result, [
      MovieEntity(
        id: result[0].id,
        title: result[0].title,
        overview: result[0].overview,
        averageGrade: result[0].averageGrade,
        releaseDate: result[0].releaseDate,
        posterPath: result[0].posterPath,
      ),
      MovieEntity(
        id: result[1].id,
        title: result[1].title,
        overview: result[1].overview,
        averageGrade: result[1].averageGrade,
        releaseDate: result[1].releaseDate,
        posterPath: result[1].posterPath,
      ),
    ]);
  });
}
