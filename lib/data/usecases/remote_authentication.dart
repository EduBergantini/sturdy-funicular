import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final CustomHttpClient httpClient;
  final String url;

  RemoteAuthentication(this.httpClient, this.url);

  Future<void> auth(AuthenticationModel model) async {
    final remoteAuthModel = RemoteAuthenticationModel.fromDomain(model);

    return await this
        .httpClient
        .request(this.url, 'POST', body: remoteAuthModel.toJson());
  }
}

class RemoteAuthenticationModel {
  final String email;
  final String password;

  RemoteAuthenticationModel(this.email, this.password);

  factory RemoteAuthenticationModel.fromDomain(AuthenticationModel model) =>
      RemoteAuthenticationModel(model.email, model.password);

  Map<String, dynamic> toJson() =>
      {'email': this.email, 'password': this.password};
}
