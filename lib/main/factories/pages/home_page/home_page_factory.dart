import 'package:movie_app/main/factories/pages/home_page/home_page_bloc_factory.dart';

import 'package:movie_app/presentation/home_page/home_page.dart';

HomePage makeHomePage() {
  return HomePage(bloc: makeHomePageBloc());
}
