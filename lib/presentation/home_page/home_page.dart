import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

class HomePage extends StatefulWidget {
  static const route = '/';
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<HomePageBloc, HomePageState>(
                bloc: widget.bloc,
                builder: (context, state) {
                  if (state is HomePageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomePageError) {
                    return Text(state.error.name);
                  } else if (state is HomePageSuccess) {
                    return ListView.separated(
                      itemCount: state.movies.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 16,
                        thickness: 2,
                        color: Colors.lightBlue,
                      ),
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          leading: SizedBox(
                            height: 48,
                            width: 48,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(movie.posterPath),
                            ),
                          ),
                          subtitle: Text(
                            movie.overview,
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}