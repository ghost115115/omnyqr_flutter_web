import 'package:omnyqr/models/token.dart';
import 'package:omnyqr/models/user.dart';

class LoginResponse {
  final User? user;
  final Tokens? tokens;
  const LoginResponse({this.user, this.tokens});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json['user']),
        tokens = Tokens.fromJson(json['tokens']);
}
