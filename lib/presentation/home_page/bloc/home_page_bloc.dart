import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/entities.dart';
import 'package:movie_app/domain/errors/errors.dart';
import 'package:movie_app/domain/usecases/usecases.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final LoadMovies loadTrendingMovies;
  final SearchMovies searchMovies;
  HomePageBloc({
    required this.loadTrendingMovies,
    required this.searchMovies,
  }) : super(HomePageInitial()) {
    on<LoadTrendingMoviesEvent>((event, emit) async {
      emit(HomePageLoading());
      try {
        final result = await loadTrendingMovies.call(
          'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
        );
        emit(HomePageSuccess(result));
      } on DomainError catch (error) {
        emit(HomePageError(error));
      }
    });

    on<RemoteSearchMoviesEvent>((event, emit) async {
      emit(HomePageLoading());
      try {
        final result = await searchMovies.call(
          'https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1',
          event.movieName,
        );
        emit(HomePageSuccess(result));
      } on DomainError catch (error) {
        emit(HomePageError(error));
      }
    });
  }
}
