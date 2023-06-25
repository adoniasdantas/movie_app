import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/domain/errors/errors.dart';

import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';
import 'package:movie_app/presentation/home_page/components/movie_list.dart';
import 'package:movie_app/presentation/home_page/components/serch_text_field.dart';

class HomePage extends StatefulWidget {
  static const route = '/home-page';
  final HomePageBloc bloc;
  const HomePage({required this.bloc, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.bloc.add(LoadTrendingMoviesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie DB'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchTextField(bloc: widget.bloc),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<HomePageBloc, HomePageState>(
                bloc: widget.bloc,
                builder: (context, state) {
                  if (state is HomePageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomePageError) {
                    return Column(
                      children: [
                        Text(state.error.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            widget.bloc.add(LoadTrendingMoviesEvent());
                          },
                          child: const Text('Reload the latest movies'),
                        ),
                      ],
                    );
                  } else if (state is HomePageSuccess) {
                    return MovieList(movies: state.movies);
                  }
                  return const Center(
                    child: Text("No videos found"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
