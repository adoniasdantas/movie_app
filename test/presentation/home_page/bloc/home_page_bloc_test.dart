import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/usecases/usecases.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/domain/errors/errors.dart';

import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

class LoadTrendingMoviesSpy extends Mock implements LoadTrendingMovies {}

class RemoteSearchMoviesSpy extends Mock implements RemoteSearchMovies {}

void main() {
  late LoadTrendingMovies loadTrendingMoviesSpy;
  late RemoteSearchMovies remoteSearchMoviesSpy;
  late HomePageBloc sut;
  late List<MovieEntity> movieList;
  late String movieName;

  setUp(() {
    loadTrendingMoviesSpy = LoadTrendingMoviesSpy();
    remoteSearchMoviesSpy = RemoteSearchMoviesSpy();
    sut = HomePageBloc(
      loadTrendingMovies: loadTrendingMoviesSpy,
      searchMovies: remoteSearchMoviesSpy,
    );
    movieName = faker.lorem.sentence();
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
    when(() => remoteSearchMoviesSpy(any(), any())).thenAnswer(
      (_) async => movieList,
    );
  });

  tearDown(() {
    sut.close();
  });

  blocTest(
    'emits [HomePageStateSuccess] if loadMovies runs successfuly',
    build: () => HomePageBloc(
      loadTrendingMovies: loadTrendingMoviesSpy,
      searchMovies: remoteSearchMoviesSpy,
    ),
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
    build: () => HomePageBloc(
      loadTrendingMovies: loadTrendingMoviesSpy,
      searchMovies: remoteSearchMoviesSpy,
    ),
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

  blocTest(
    'emits [HomePageStateSuccess] if remoteSearchMovies runs successfuly',
    build: () => HomePageBloc(
      loadTrendingMovies: loadTrendingMoviesSpy,
      searchMovies: remoteSearchMoviesSpy,
    ),
    act: (bloc) => bloc.add(RemoteSearchMoviesEvent(movieName)),
    verify: (_) => verify(() => remoteSearchMoviesSpy(any(), any())).called(1),
    expect: () => [
      isA<HomePageLoading>(),
      isA<HomePageSuccess>()
          .having((success) => success.movies, 'movies', movieList)
    ],
  );
}
