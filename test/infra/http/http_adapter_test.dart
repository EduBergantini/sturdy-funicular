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

  group('POST', () {
    test('Should call post with correct values', () async {
      final httpClient = HttpClientMock();
      final url = faker.internet.httpUrl();
      final sut = HttpAdapter(httpClient);

      when(() => httpClient.post(any<Uri>()))
          .thenAnswer((invocation) async => Response("", 200));

      await sut.request(url, 'POST');

      verify(() => httpClient.post(Uri.parse(url)));
    });
  });
}
