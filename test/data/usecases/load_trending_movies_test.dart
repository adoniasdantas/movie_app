import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/data/usecases/usecases.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/errors/errors.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClientSpy;
  late String url;
  late String token;
  late LoadTrendingMovies sut;

  When mockRequest() => when(
        () => httpClientSpy.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          headers: any(named: 'headers'),
        ),
      );

  void mockRequestCall(dynamic data) =>
      mockRequest().thenAnswer((_) async => data);

  void mockRequestError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClientSpy = HttpClientSpy();
    url = faker.internet.httpUrl();
    token = faker.jwt.valid();
    mockRequestCall({
      'results': [
        {
          "id": faker.randomGenerator.integer(100),
          "title": faker.lorem.sentence(),
          "overview": faker.lorem.sentence(),
          "vote_average": 7,
          "release_date": '2023-01-01',
          "poster_path": faker.internet.httpUrl(),
        },
        {
          "id": faker.randomGenerator.integer(100),
          "title": faker.lorem.sentence(),
          "overview": faker.lorem.sentence(),
          "vote_average": faker.randomGenerator.decimal(scale: 2, min: 0),
          "release_date": '2023-01-02',
          "poster_path": faker.internet.httpUrl(),
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
        releaseDate: DateTime.parse('2023-01-01'),
        posterPath: result[0].posterPath,
      ),
      MovieEntity(
        id: result[1].id,
        title: result[1].title,
        overview: result[1].overview,
        averageGrade: result[1].averageGrade,
        releaseDate: DateTime.parse('2023-01-02'),
        posterPath: result[1].posterPath,
      ),
    ]);
  });

  test('Should return UnexpectedError if httpClient returns invalid data',
      () async {
    mockRequestCall(
      {
        'results': [
          {
            "Id": faker.randomGenerator.integer(100),
            "Title": faker.lorem.sentence(),
            "Overview": faker.lorem.sentence(),
            "Vote_average": faker.randomGenerator.decimal(scale: 2, min: 0),
            "Release_date": faker.date.dateTime(),
            "Poster_path": faker.internet.httpUrl(),
          },
        ]
      },
    );

    final future = sut(url);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockRequestError(HttpError.notFound);

    final future = sut(url);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockRequestError(HttpError.serverError);

    final future = sut(url);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 401', () async {
    mockRequestError(HttpError.unauthorized);

    final future = sut(url);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
