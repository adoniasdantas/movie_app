import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_app/main/factories/pages/home_page/home_page_factory.dart';

import 'presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: HomePage.route,
      builder: (context, state) => makeHomePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
