import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_app/data/http/http.dart';
import 'package:movie_app/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late ClientSpy clientSpy;
  late HttpAdapter sut;
  late String url;
  late String token;
  late Map<String, String> headers;

  group('GET Request', () {
    When mockClientGet() =>
        when(() => clientSpy.get(any(), headers: any(named: 'headers')));

    void mockClientGetCall(Response response) =>
        mockClientGet().thenAnswer((_) async => response);

    setUp(() {
      clientSpy = ClientSpy();
      url = faker.internet.httpUrl();
      token = faker.jwt.valid();
      headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      sut = HttpAdapter(client: clientSpy);
      registerFallbackValue(Uri.parse(url));
      mockClientGetCall(Response('{"any_key": "any_value"}', 200));
    });

    test('Should call GET with correct values', () async {
      await sut.request(url: url, method: 'GET', headers: headers);

      verify(() => clientSpy.get(Uri.parse(url), headers: headers));
    });

    test('Should return data if GET returns 200', () async {
      final result =
          await sut.request(url: url, method: 'GET', headers: headers);

      expect(result, {"any_key": "any_value"});
    });

    test('Should return BadRequestError if GET returns 400', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 400));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if GET returns 401', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 401));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return UnauthorizedError if GET returns 403', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 403));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return NotFoundError if GET returns 404', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 404));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return BadRequestError if GET returns 405', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 405));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if GET returns 406', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 406));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return ServerError if GET returns value >= 500', () async {
      mockClientGetCall(Response('{"any_key": "any_value"}', 500));
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if GET throws any Exception', () async {
      mockClientGet().thenThrow(Exception());
      final future = sut.request(url: url, method: 'GET', headers: headers);

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
