import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:blog/domain/helpers/helpers.dart';
import 'package:blog/domain/usecases/authentication.dart';
import 'package:blog/data/http/http.dart';
import 'package:blog/data/usecases/remote_authentication.dart';

class MockCustomHttpClient extends Mock implements CustomHttpClient {}

void main() {
  CustomHttpClient httpClient = MockCustomHttpClient();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut = RemoteAuthentication(httpClient, url);
  AuthenticationModel model =
      AuthenticationModel(faker.internet.email(), faker.internet.password());

  When _mockRequest() => when(() => httpClient
      .request(any<String>(), any<String>(), body: any(named: 'body')));

  void _mockHttpSuccess(Map<String, dynamic>? data) {
    _mockRequest().thenAnswer((_) => Future<Map?>.value(data));
  }

  void _mockHttpError(HttpError error) {
    _mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockCustomHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient, url);
    model =
        AuthenticationModel(faker.internet.email(), faker.internet.password());
  });

  test('Should call CustomHttpClient with correct values', () async {
    _mockHttpSuccess({'accessToken': 'any_value'});

    await sut.authenticate(model);

    verify(() => httpClient.request(url, 'POST',
        body: {'email': model.email, 'password': model.password}));
  });

  test('Should throw InvalidModelError when CustomHttpClient returns 400',
      () async {
    _mockHttpError(HttpError.badRequest);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.invalidModel));
  });

  test('Should throw InvalidCredentialsError when CustomHttpClient returns 401',
      () async {
    _mockHttpError(HttpError.unauthorized);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError when CustomHttpClient returns 404',
      () async {
    _mockHttpError(HttpError.notFound);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError when CustomHttpClient returns 500',
      () async {
    _mockHttpError(HttpError.serverError);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should an AccountEntity when CustomHttpClient returns 200', () async {
    final fakeAccessToken = faker.guid.guid();

    _mockHttpSuccess({'accessToken': fakeAccessToken});

    final account = await sut.authenticate(model);

    expect(account.token, fakeAccessToken);
  });

  test(
      'Should throw UnexpectedError when CustomHttpClient returns 200 with invalid data',
      () async {
    _mockHttpSuccess({'invalid_key': 'value'});

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError when CustomHttpClient returns null',
      () async {
    _mockHttpSuccess(null);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });
}
