import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:moovbr/domain/helpers/helpers.dart';
import 'package:moovbr/domain/usecases/authentication.dart';
import 'package:moovbr/data/http/http.dart';
import 'package:moovbr/data/usecases/remote_authentication.dart';

class MockCustomHttpClient extends Mock implements CustomHttpClient {}

void main() {
  CustomHttpClient httpClient = MockCustomHttpClient();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut = RemoteAuthentication(httpClient, url);
  AuthenticationModel model =
      AuthenticationModel(faker.internet.email(), faker.internet.password());

  setUp(() {
    httpClient = MockCustomHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient, url);
    model =
        AuthenticationModel(faker.internet.email(), faker.internet.password());
  });

  test('Should call CustomHttpClient with correct values', () async {
    when(() => httpClient.request(any<String>(), any<String>(),
            body: any(named: 'body')))
        .thenAnswer((_) => Future<Map?>.value({'accessToken': 'any_value'}));

    await sut.authenticate(model);

    verify(() => httpClient.request(url, 'POST',
        body: {'email': model.email, 'password': model.password}));
  });

  test('Should throw InvalidModelError when CustomHttpClient returns 400',
      () async {
    when(() => httpClient.request(any<String>(), any<String>(),
        body: any(named: 'body'))).thenThrow(HttpError.badRequest);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.invalidModel));
  });

  test('Should throw InvalidCredentialsError when CustomHttpClient returns 401',
      () async {
    when(() => httpClient.request(any<String>(), any<String>(),
        body: any(named: 'body'))).thenThrow(HttpError.unauthorized);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError when CustomHttpClient returns 404',
      () async {
    when(() => httpClient.request(any<String>(), any<String>(),
        body: any(named: 'body'))).thenThrow(HttpError.notFound);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError when CustomHttpClient returns 500',
      () async {
    when(() => httpClient.request(any<String>(), any<String>(),
        body: any(named: 'body'))).thenThrow(HttpError.serverError);

    final future = sut.authenticate(model);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should an AccountEntity when CustomHttpClient returns 200', () async {
    final fakeAccessToken = faker.guid.guid();

    when(() => httpClient.request(any<String>(), any<String>(),
            body: any(named: 'body')))
        .thenAnswer((_) async => {'accessToken': fakeAccessToken});

    final account = await sut.authenticate(model);

    expect(account?.token, fakeAccessToken);
  });
}
