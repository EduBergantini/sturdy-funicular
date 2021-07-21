import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:moovbr/data/http/custom_http_client.dart';
import 'package:moovbr/data/usecases/remote_authentication.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([CustomHttpClient])
void main() {
  CustomHttpClient httpClient = MockCustomHttpClient();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut = RemoteAuthentication(httpClient, url);

  setUp(() {
    httpClient = MockCustomHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient, url);
  });

  test('Should call CustomHttpClient with correct values', () async {
    await sut.auth();

    verify(httpClient.request(url, 'POST'));
  });
}
