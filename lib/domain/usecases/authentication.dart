import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity?> authenticate(AuthenticationModel authenticationModel);
}

class AuthenticationModel {
  final String email;
  final String password;

  AuthenticationModel(this.email, this.password);

  Map<String, dynamic> toJson() =>
      {'email': this.email, 'password': this.password};
}
