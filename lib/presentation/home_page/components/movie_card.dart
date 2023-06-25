import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_app/domain/entities/entities.dart';
import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.title),
      leading: SizedBox(
        height: 48,
        width: 48,
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(movie.posterPath),
        ),
      ),
      subtitle: Text(
        movie.overview,
        maxLines: 3,
        overflow: TextOverflow.fade,
      ),
      trailing: BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
        builder: (context, state) {
          final favoriteMoviesBloc = context.read<FavoriteMoviesBloc>();
          final isFavorite = state.favoriteMoviesIds.contains(
            movie.id,
          );
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
            ),
            onPressed: () {
              favoriteMoviesBloc.add(
                isFavorite
                    ? RemoveFavoriteMovieEvent(movie.id)
                    : SaveFavoriteMovieEvent(movie.id),
              );
            },
          );
        },
      ),
    );
  }
}
