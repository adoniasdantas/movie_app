import 'package:flutter/material.dart';

import 'package:movie_app/domain/entities/movie_entity.dart';
import 'package:movie_app/presentation/home_page/components/movie_card.dart';

class MovieList extends StatelessWidget {
  final List<MovieEntity> movies;
  const MovieList({required this.movies, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: movies.length,
      separatorBuilder: (context, index) => const Divider(
        height: 16,
        thickness: 2,
        color: Colors.lightBlue,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(movie: movie);
      },
    );
  }
}
