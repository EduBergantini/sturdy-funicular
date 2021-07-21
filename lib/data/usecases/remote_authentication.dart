import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final CustomHttpClient httpClient;
  final String url;

  RemoteAuthentication(this.httpClient, this.url);

  Future<void> auth(AuthenticationModel model) async {
    return await this
        .httpClient
        .request(this.url, 'POST', body: model.toJson());
  }
}
