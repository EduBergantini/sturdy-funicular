import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:moovbr/data/infra/http/http_adapter.dart';

class HttpClientMock extends Mock implements Client {}

void main() {
  setUpAll(() {
    final url = Uri.parse(faker.internet.httpUrl());
    registerFallbackValue(url);
  });

  HttpClientMock httpClient = HttpClientMock();
  String url = faker.internet.httpUrl();
  HttpAdapter sut = HttpAdapter(httpClient);
  final String httpResponseBody = '{"any_key": "any_value"}';

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = HttpAdapter(httpClient);
  });

  group('POST', () {
    When _mockRequest() => when(() => httpClient.post(any<Uri>(),
        headers: any(named: 'headers'), body: any(named: 'body')));

    void _mockHttpSuccess(String responseBody, int statusCode) {
      _mockRequest().thenAnswer(
          (invocation) => Future.value(Response(responseBody, statusCode)));
    }

    setUp(() {
      _mockHttpSuccess(httpResponseBody, 200);
    });

    test('Should call post with correct values', () async {
      final fakeBody = {'any_key': 'any_value'};

      await sut.request(url, 'POST', body: fakeBody);

      verify(() => httpClient.post(Uri.parse(url),
          headers: {
            'User-Agent': 'MoovBR.Mobile/1.0.0',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(fakeBody)));
    });

    test('Should call post without body', () async {
      await sut.request(url, 'POST');

      verify(() => httpClient.post(Uri.parse(url), headers: {
            'User-Agent': 'MoovBR.Mobile/1.0.0',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }));
    });

    test('Should return data when post return 200', () async {
      final result = await sut.request(url, 'POST');

      expect(result, {'any_key': 'any_value'});
    });

    test('Should return null when post return 200 with no data', () async {
      _mockHttpSuccess('', 200);

      final result = await sut.request(url, 'POST');

      expect(result, null);
    });
  });
}
