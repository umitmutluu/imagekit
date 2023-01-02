class AuthEndpointRespose {
  final int expire;
  final String signature;
  final String token;
  AuthEndpointRespose({
    required this.expire,
    required this.signature,
    required this.token,
  });

  factory AuthEndpointRespose.fromMap(Map<String, dynamic> map) {
    return AuthEndpointRespose(
      expire: map['expire'] as int,
      signature: map['signature'] as String,
      token: map['token'] as String,
    );
  }

  @override
  String toString() =>
      'AuthRespose(expire: $expire, signature: $signature, token: $token)';
}
