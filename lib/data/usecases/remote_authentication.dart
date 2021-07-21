import 'package:moovbr/domain/usecases/authentication.dart';

import '../http/custom_http_client.dart';

class RemoteAuthentication {
  final CustomHttpClient httpClient;
  final String url;

  RemoteAuthentication(this.httpClient, this.url);

  Future<void> auth(AuthenticationModel model) async {
    final body = {'email': model.email, 'password': model.password};
    return await this.httpClient.request(this.url, 'POST', body: body);
  }
}
