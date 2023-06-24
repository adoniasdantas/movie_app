import 'package:movie_app/main/factories/data/usecases/load_trending_movies_factory.dart';
import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

HomePageBloc makeHomePageBloc() {
  return HomePageBloc(loadTrendingMovies: makeLoadTrendingMovies());
}
