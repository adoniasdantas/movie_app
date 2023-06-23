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
    await client.get(Uri.parse(url), headers: customHeaders);
    return Future.value('');
  }
}

void main() {
  test('Should call GET with correct values', () async {
    final clientSpy = ClientSpy();
    final sut = HttpAdapter(client: clientSpy);
    final url = faker.internet.httpUrl();
    final token = faker.jwt.valid();
    registerFallbackValue(Uri.parse(url));
    when(() => clientSpy.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => Response("{}", 200));

    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    await sut.request(url: url, method: 'GET', headers: headers);

    verify(() => clientSpy.get(Uri.parse(url), headers: headers));
  });
}
