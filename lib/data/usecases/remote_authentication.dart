import 'package:moovbr/data/models/remote_account_model.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication implements Authentication {
  final CustomHttpClient httpClient;
  final String url;

  RemoteAuthentication(this.httpClient, this.url);

  @override
  Future<AccountEntity?> authenticate(AuthenticationModel model) async {
    final remoteAuthModel = RemoteAuthenticationModel.fromDomain(model);

    try {
      final response = await this
          .httpClient
          .request(this.url, 'POST', body: remoteAuthModel.toJson());

      //TODO: testar resposta nula
      if (response == null) {
        throw HttpError.invalidResponseData;
      }

      return RemoteAccountModel.fromJson(response).toDomain();
    } on HttpError catch (e) {
      switch (e) {
        case HttpError.badRequest:
          throw DomainError.invalidModel;
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
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
