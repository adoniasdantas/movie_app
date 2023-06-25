part of 'favorite_movies_bloc.dart';

abstract class FavoriteMoviesEvent extends Equatable {
  const FavoriteMoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoriteMoviesEvent extends FavoriteMoviesEvent {}

class SaveFavoriteMovieEvent extends FavoriteMoviesEvent {
  final int movieId;
  const SaveFavoriteMovieEvent(this.movieId);
}
