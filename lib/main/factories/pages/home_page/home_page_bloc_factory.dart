import 'package:movie_app/main/factories/data/usecases/usecases.dart';
import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

HomePageBloc makeHomePageBloc() {
  return HomePageBloc(
    loadTrendingMovies: makeLoadTrendingMovies(),
    searchMovies: makeRemoteSearchMovies(),
  );
}
