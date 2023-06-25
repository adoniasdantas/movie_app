import 'package:movie_app/main/factories/data/usecases/usecases.dart';

import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';

FavoriteMoviesBloc makeFavoriteMoviesBloc() {
  return FavoriteMoviesBloc(
    saveFavoriteMovies: makeCacheSaveFavoriteMovies(),
    loadFavoriteMovies: makeCacheLoadFavoriteMovies(),
  );
}
