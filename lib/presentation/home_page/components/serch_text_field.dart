import 'package:flutter/material.dart';
import 'package:movie_app/presentation/home_page/bloc/home_page_bloc.dart';

class SearchTextField extends StatelessWidget {
  final HomePageBloc bloc;
  final movieNameController = TextEditingController();
  SearchTextField({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: movieNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              hintText: 'Movie name (at least 3 characters)',
            ),
          ),
        ),
        const SizedBox(width: 8),
        ValueListenableBuilder(
          valueListenable: movieNameController,
          builder: (context, value, child) {
            return IconButton(
              onPressed: movieNameController.text.length > 2
                  ? () => bloc.add(
                        RemoteSearchMoviesEvent(
                          movieNameController.text,
                        ),
                      )
                  : null,
              icon: const Icon(
                Icons.search,
                color: Colors.lightBlue,
              ),
            );
          },
        ),
      ],
    );
  }
}
