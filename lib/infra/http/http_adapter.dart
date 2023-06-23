import 'dart:convert';

import 'package:http/http.dart';

import 'package:movie_app/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  const HttpAdapter({required this.client});

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map? headers,
  }) async {
    final customHeaders = headers?.cast<String, String>();
    try {
      final response = await client.get(Uri.parse(url), headers: customHeaders);
      return _decodeResponse(response);
    } on HttpError {
      rethrow;
    } catch (_) {
      throw HttpError.serverError;
    }
  }

  dynamic _decodeResponse(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400 ||
        response.statusCode == 405 ||
        response.statusCode == 406) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else if (response.statusCode >= 500) {
      throw HttpError.serverError;
    }
  }
}
