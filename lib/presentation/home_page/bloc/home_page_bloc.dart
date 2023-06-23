import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/domain/entities/entities.dart';
import 'package:movie_app/domain/usecases/load_movies.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final LoadMovies loadTrendingMovies;
  HomePageBloc({required this.loadTrendingMovies}) : super(HomePageInitial()) {
    on<LoadTrendingMoviesEvent>((event, emit) async {
      emit(HomePageLoading());
      final result = await loadTrendingMovies.call(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
      );
      emit(HomePageSuccess(result));
    });
  }
}
