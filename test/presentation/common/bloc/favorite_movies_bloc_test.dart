import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';

class SaveFavoriteMoviesSpy extends Mock implements SaveFavoriteMovies {}

class LoadFavoriteMoviesSpy extends Mock implements LoadFavoriteMovies {}

void main() {
  late SaveFavoriteMovies saveFavoriteMoviesSpy;
  late LoadFavoriteMovies loadFavoriteMoviesSpy;
  late FavoriteMoviesBloc sut;
  late List<int> favoriteMoviesIds;
  late int movieId;

  setUp(() {
    loadFavoriteMoviesSpy = LoadFavoriteMoviesSpy();
    saveFavoriteMoviesSpy = SaveFavoriteMoviesSpy();
    sut = FavoriteMoviesBloc(
      saveFavoriteMovies: saveFavoriteMoviesSpy,
      loadFavoriteMovies: loadFavoriteMoviesSpy,
    );
    movieId = faker.randomGenerator.integer(100, min: 1);
    favoriteMoviesIds = faker.randomGenerator.numbers(100, 3);
    when(() => loadFavoriteMoviesSpy()).thenAnswer(
      (_) async => favoriteMoviesIds,
    );
    when(() => saveFavoriteMoviesSpy(any())).thenAnswer((_) async => _);
  });

  tearDown(() {
    sut.close();
  });

  blocTest(
    'emits [FavoriteMoviesSuccess] if loadFavoriteMovies runs successfuly',
    build: () => FavoriteMoviesBloc(
      saveFavoriteMovies: saveFavoriteMoviesSpy,
      loadFavoriteMovies: loadFavoriteMoviesSpy,
    ),
    act: (bloc) => bloc.add(LoadFavoriteMoviesEvent()),
    verify: (_) => verify(() => loadFavoriteMoviesSpy()).called(1),
    expect: () => [
      isA<FavoriteMoviesLoading>(),
      isA<FavoriteMoviesSuccess>().having(
        (success) => success.favoriteMoviesIds,
        'favoriteMoviesIds',
        favoriteMoviesIds,
      )
    ],
  );

  blocTest(
    'emits [FavoriteMoviesError] if loadFavoriteMovies throws any error',
    build: () => FavoriteMoviesBloc(
      saveFavoriteMovies: saveFavoriteMoviesSpy,
      loadFavoriteMovies: loadFavoriteMoviesSpy,
    ),
    act: (bloc) {
      when(() => loadFavoriteMoviesSpy()).thenThrow(DomainError.unexpected);
      bloc.add(LoadFavoriteMoviesEvent());
    },
    verify: (_) => verify(() => loadFavoriteMoviesSpy()).called(1),
    expect: () => [
      isA<FavoriteMoviesLoading>(),
      isA<FavoriteMoviesError>().having(
          (errorState) => errorState.error, 'error', DomainError.unexpected)
    ],
  );

  blocTest(
    'emits [FavoriteMoviesSuccess] if saveFavoriteMovie runs successfuly',
    build: () => FavoriteMoviesBloc(
      saveFavoriteMovies: saveFavoriteMoviesSpy,
      loadFavoriteMovies: loadFavoriteMoviesSpy,
    ),
    act: (bloc) => bloc.add(SaveFavoriteMovieEvent(movieId)),
    verify: (_) => verify(() => saveFavoriteMoviesSpy(any())).called(1),
    expect: () => [
      isA<FavoriteMoviesLoading>(),
      isA<FavoriteMoviesSuccess>().having(
        (success) => success.favoriteMoviesIds,
        'favoriteMoviesIds',
        [movieId],
      )
    ],
  );
}
