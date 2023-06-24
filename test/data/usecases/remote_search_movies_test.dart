import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/data/models/models.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

final validResponse = {
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
};

final invalidResponse = {
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
};

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteSearchMovies implements SearchMovies {
  final String token;
  final HttpClient httpClient;

  const RemoteSearchMovies({
    required this.httpClient,
    required this.token,
  });

  @override
  Future<List<MovieEntity>> call(String url, String movieName) async {
    try {
      final data = await httpClient.request(
        url: '$url&query=$movieName',
        method: 'GET',
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      return (data['results'] as List)
          .map((movieJson) => MovieModel.fromJson(movieJson).toEntity())
          .toList();
    } on HttpError catch (httpError) {
      throw httpError == HttpError.unauthorized
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

void main() {
  late HttpClientSpy httpClientSpy;
  late String url;
  late String token;
  late String movieName;
  late SearchMovies sut;

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
    movieName = faker.lorem.sentence();
    sut = RemoteSearchMovies(httpClient: httpClientSpy, token: token);
    mockRequestCall(validResponse);
  });

  test('Should call httpClient with correct values', () async {
    await sut(url, movieName);

    verify(
      () => httpClientSpy.request(
        url: '$url&query=$movieName',
        method: 'GET',
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    ).called(1);
  });

  test('Should return a list of MovieEntity', () async {
    final result = await sut(url, movieName);

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
    mockRequestCall(invalidResponse);

    final future = sut(url, movieName);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockRequestError(HttpError.notFound);

    final future = sut(url, movieName);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockRequestError(HttpError.serverError);

    final future = sut(url, movieName);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 401', () async {
    mockRequestError(HttpError.unauthorized);

    final future = sut(url, movieName);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
