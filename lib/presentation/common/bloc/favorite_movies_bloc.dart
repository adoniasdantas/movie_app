import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/errors/errors.dart';

import 'package:movie_app/domain/usecases/usecases.dart';

part 'favorite_movies_event.dart';
part 'favorite_movies_state.dart';

class FavoriteMoviesBloc
    extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final SaveFavoriteMovies saveFavoriteMovies;
  final LoadFavoriteMovies loadFavoriteMovies;
  FavoriteMoviesBloc({
    required this.saveFavoriteMovies,
    required this.loadFavoriteMovies,
  }) : super(FavoriteMoviesInitial()) {
    on<LoadFavoriteMoviesEvent>((event, emit) async {
      try {
        emit(FavoriteMoviesLoading());
        final favoriteMoviesIds = await loadFavoriteMovies();
        emit(FavoriteMoviesSuccess(favoriteMoviesIds));
      } on DomainError catch (error) {
        emit(FavoriteMoviesError(error));
      }
    });
  }
}
