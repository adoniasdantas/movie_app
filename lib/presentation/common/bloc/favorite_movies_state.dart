part of 'favorite_movies_bloc.dart';

abstract class FavoriteMoviesState extends Equatable {
  final List<int> favoriteMoviesIds;
  const FavoriteMoviesState(this.favoriteMoviesIds);

  const FavoriteMoviesState.copyWith(this.favoriteMoviesIds);

  @override
  List<Object> get props => [favoriteMoviesIds];
}

class FavoriteMoviesInitial extends FavoriteMoviesState {
  FavoriteMoviesInitial() : super.copyWith([]);
}

class FavoriteMoviesLoading extends FavoriteMoviesState {
  const FavoriteMoviesLoading(super.favoriteMoviesIds);
}

class FavoriteMoviesSuccess extends FavoriteMoviesState {
  const FavoriteMoviesSuccess(super.favoriteMoviesIds);
}

class FavoriteMoviesError extends FavoriteMoviesState {
  final DomainError error;
  const FavoriteMoviesError(super.favoriteMoviesIds, this.error);
}
