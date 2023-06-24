import 'package:movie_app/infra/http/http.dart';
import 'package:http/http.dart';

HttpAdapter makeHttpAdapter() {
  return HttpAdapter(client: Client());
}
