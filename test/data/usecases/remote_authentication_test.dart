import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moovbr/data/http/custom_http_client.dart';
import 'package:test/test.dart';

import 'package:moovbr/data/usecases/remote_authentication.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([CustomHttpClient])
void main() {
  test('Should call CustomHttpClient with correct url', () async {
    final httpClient = MockCustomHttpClient();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient, url);

    await sut.auth();

    verify(httpClient.request(url));
  });
}
