import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/main/factories/data/usecases/usecases.dart';

import 'package:movie_app/main/factories/pages/home_page/home_page_factory.dart';
import 'package:movie_app/main/factories/pages/splash_page/splash_page_factory.dart';
import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';
import 'package:movie_app/presentation/splash_page/splash_page.dart';

import 'presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteMoviesBloc(
        saveFavoriteMovies: makeCacheSaveFavoriteMovies(),
        loadFavoriteMovies: makeCacheLoadFavoriteMovies(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.route,
        routes: {
          SplashPage.route: (context) => makeSplashPage(
                context.read<FavoriteMoviesBloc>(),
              ),
          HomePage.route: (context) => makeHomePage(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
