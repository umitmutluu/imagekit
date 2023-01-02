class Configuration {
  final String publicKey;
  final String urlEndpoint;
  final String authenticationEndpoint;

  const Configuration({
    required this.publicKey,
    required this.urlEndpoint,
    required this.authenticationEndpoint,
  });

  String getPublicKey() {
    return publicKey;
  }

  String getUrlEndpoint() {
    return urlEndpoint;
  }

  String getAuthenticationEndpoint() {
    return authenticationEndpoint;
  }

  @override
  String toString() =>
      'Configuration(publicKey: $publicKey, urlEndpoint: $urlEndpoint, authenticationEndpoint: $getAuthenticationEndpoint)';
}
