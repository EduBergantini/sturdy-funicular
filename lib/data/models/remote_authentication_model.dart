import '../../domain/usecases/usecases.dart';

class RemoteAuthenticationModel {
  final String email;
  final String password;

  RemoteAuthenticationModel(this.email, this.password);

  factory RemoteAuthenticationModel.fromDomain(AuthenticationModel model) =>
      RemoteAuthenticationModel(model.email, model.password);

  Map<String, dynamic> toJson() =>
      {'email': this.email, 'password': this.password};
}
