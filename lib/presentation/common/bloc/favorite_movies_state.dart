part of 'favorite_movies_bloc.dart';

abstract class FavoriteMoviesState extends Equatable {
  const FavoriteMoviesState();

  @override
  List<Object> get props => [];
}

class FavoriteMoviesInitial extends FavoriteMoviesState {}

class FavoriteMoviesLoading extends FavoriteMoviesState {}

class FavoriteMoviesSuccess extends FavoriteMoviesState {
  final List<int> favoriteMoviesIds;
  const FavoriteMoviesSuccess(this.favoriteMoviesIds);
}

class FavoriteMoviesError extends FavoriteMoviesState {
  final DomainError error;
  const FavoriteMoviesError(this.error);
}
