import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/usecases/usecases.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/errors/errors.dart';

import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

class LoadTrendingMoviesSpy extends Mock implements LoadTrendingMovies {}

void main() {
  late LoadTrendingMovies loadTrendingMoviesSpy;
  late HomePageBloc sut;
  late List<MovieEntity> movieList;

  setUp(() {
    loadTrendingMoviesSpy = LoadTrendingMoviesSpy();
    sut = HomePageBloc(loadTrendingMovies: loadTrendingMoviesSpy);
    movieList = [
      MovieEntity(
        id: faker.randomGenerator.integer(100),
        title: faker.lorem.sentence(),
        overview: faker.lorem.sentence(),
        averageGrade: faker.randomGenerator.decimal(scale: 2, min: 0),
        releaseDate: faker.date.dateTime(),
        posterPath: faker.internet.httpUrl(),
      ),
      MovieEntity(
        id: faker.randomGenerator.integer(100),
        title: faker.lorem.sentence(),
        overview: faker.lorem.sentence(),
        averageGrade: faker.randomGenerator.decimal(scale: 2, min: 0),
        releaseDate: faker.date.dateTime(),
        posterPath: faker.internet.httpUrl(),
      )
    ];
    when(() => loadTrendingMoviesSpy(any())).thenAnswer((_) async => movieList);
  });

  tearDown(() {
    sut.close();
  });

  blocTest(
    'emits [HomePageStateSuccess] if loadMovies runs successfuly',
    build: () => HomePageBloc(loadTrendingMovies: loadTrendingMoviesSpy),
    act: (bloc) => bloc.add(LoadTrendingMoviesEvent()),
    verify: (_) => verify(() => loadTrendingMoviesSpy(any())).called(1),
    expect: () => [
      isA<HomePageLoading>(),
      isA<HomePageSuccess>()
          .having((success) => success.movies, 'movies', movieList)
    ],
  );

  blocTest(
    'emits [HomePageStateError] if loadMovies throws any error',
    build: () => HomePageBloc(loadTrendingMovies: loadTrendingMoviesSpy),
    act: (bloc) {
      when(() => loadTrendingMoviesSpy(any()))
          .thenThrow(DomainError.unexpected);
      bloc.add(LoadTrendingMoviesEvent());
    },
    verify: (_) => verify(() => loadTrendingMoviesSpy(any())).called(1),
    expect: () => [
      isA<HomePageLoading>(),
      isA<HomePageError>().having(
          (errorState) => errorState.error, 'error', DomainError.unexpected)
    ],
  );
}
