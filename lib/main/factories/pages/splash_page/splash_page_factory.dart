import 'package:movie_app/presentation/common/bloc/favorite_movies_bloc.dart';

import 'package:movie_app/presentation/splash_page/splash_page.dart';

SplashPage makeSplashPage(FavoriteMoviesBloc bloc) {
  return SplashPage(bloc: bloc);
}
