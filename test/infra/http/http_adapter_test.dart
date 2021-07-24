import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moovbr/data/http/http.dart';
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

    void _mockHttpResult(int statusCode, {String responseBody = ''}) {
      _mockRequest().thenAnswer(
          (invocation) => Future.value(Response(responseBody, statusCode)));
    }

    setUp(() {
      _mockHttpResult(200, responseBody: httpResponseBody);
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
      _mockHttpResult(200);

      final result = await sut.request(url, 'POST');

      expect(result, null);
    });

    test('Should return null when post return 204', () async {
      _mockHttpResult(204);

      final result = await sut.request(url, 'POST');

      expect(result, null);
    });

    test('Should return null when post return 204 with data', () async {
      _mockHttpResult(204, responseBody: httpResponseBody);

      final result = await sut.request(url, 'POST');

      expect(result, null);
    });

    test('Should throw BadRequestError when post return 400 with data',
        () async {
      _mockHttpResult(400, responseBody: httpResponseBody);

      final future = sut.request(url, 'POST');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should throw BadRequestError when post return 400', () async {
      _mockHttpResult(400);

      final future = sut.request(url, 'POST');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should throw UnauthorizedError when post return 401', () async {
      _mockHttpResult(401);

      final future = sut.request(url, 'POST');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should throw ServerError when post return 500', () async {
      _mockHttpResult(500);

      final future = sut.request(url, 'POST');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
