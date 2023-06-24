part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class LoadTrendingMoviesEvent extends HomePageEvent {}

class RemoteSearchMoviesEvent extends HomePageEvent {
  final String movieName;
  const RemoteSearchMoviesEvent(this.movieName);
}
