import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';
import 'package:movie_app/presentation/home_page/home_page.dart';

class SplashPage extends StatelessWidget {
  static const route = '/splash';
  final FavoriteMoviesBloc bloc;
  const SplashPage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<FavoriteMoviesBloc, FavoriteMoviesState>(
          bloc: bloc..add(LoadFavoriteMoviesEvent()),
          listenWhen: (previous, current) =>
              current is FavoriteMoviesInitial ||
              current is FavoriteMoviesError,
          listener: (context, state) {
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          },
          buildWhen: (previous, current) => current is! FavoriteMoviesInitial,
          builder: (context, state) {
            if (state is FavoriteMoviesLoading) {
              return const CircularProgressIndicator();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
