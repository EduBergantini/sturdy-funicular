import '../http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidResponseData;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toDomain() => AccountEntity(this.accessToken);
}
