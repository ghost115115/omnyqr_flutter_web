class Tokens {
  final Token? access;
  final Token? refresh;

  Tokens({this.access, this.refresh});

  Tokens.fromJson(Map<String, dynamic> json)
      : access = Token.fromJson(json['access']),
        refresh = Token.fromJson(json['refresh']);
}

class Token {
  final String? token;
  final String? expires;

  Token({this.token, this.expires});

  Token.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        expires = json['expires'];
}
