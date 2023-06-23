import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/http/http.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  const HttpAdapter({required this.client});

  @override
  Future request({
    required String url,
    required String method,
    Map? headers,
  }) async {
    final customHeaders = headers?.cast<String, String>();
    final response = await client.get(Uri.parse(url), headers: customHeaders);
    if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    }
    return jsonDecode(response.body);
  }
}

void main() {
  late ClientSpy clientSpy;
  late HttpAdapter sut;
  late String url;
  late String token;
  late Map<String, String> headers;

  setUp(() {
    clientSpy = ClientSpy();
    url = faker.internet.httpUrl();
    token = faker.jwt.valid();
    headers = {'accept': 'application/json', 'Authorization': 'Bearer $token'};
    sut = HttpAdapter(client: clientSpy);
    registerFallbackValue(Uri.parse(url));
    when(() => clientSpy.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));
  });

  test('Should call GET with correct values', () async {
    await sut.request(url: url, method: 'GET', headers: headers);

    verify(() => clientSpy.get(Uri.parse(url), headers: headers));
  });

  test('Should return data if GET returns 200', () async {
    final result = await sut.request(url: url, method: 'GET', headers: headers);

    expect(result, {"any_key": "any_value"});
  });

  test('Should return BadRequestError if GET returns 400', () async {
    when(
      () => clientSpy.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => Response('{"any_key": "any_value"}', 400),
    );
    final future = sut.request(url: url, method: 'GET', headers: headers);

    expect(future, throwsA(HttpError.badRequest));
  });

  test('Should return UnauthorizedError if GET returns 401', () async {
    when(
      () => clientSpy.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => Response('{"any_key": "any_value"}', 401),
    );
    final future = sut.request(url: url, method: 'GET', headers: headers);

    expect(future, throwsA(HttpError.unauthorized));
  });

  test('Should return UnauthorizedError if GET returns 403', () async {
    when(
      () => clientSpy.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => Response('{"any_key": "any_value"}', 403),
    );
    final future = sut.request(url: url, method: 'GET', headers: headers);

    expect(future, throwsA(HttpError.unauthorized));
  });

  test('Should return NotFoundError if GET returns 404', () async {
    when(
      () => clientSpy.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => Response('{"any_key": "any_value"}', 404),
    );
    final future = sut.request(url: url, method: 'GET', headers: headers);

    expect(future, throwsA(HttpError.notFound));
  });
}
