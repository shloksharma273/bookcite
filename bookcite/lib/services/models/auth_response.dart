class AuthResponse {
  final String accessToken;
  final String refreshToken;

  AuthResponse({required this.accessToken, required this.refreshToken});

  factory AuthResponse.fromJSON({Map<String, dynamic>? json}) {
    return AuthResponse(
        accessToken: json?['access'] as String,
        refreshToken: json?['refresh'] as String);
  }
}
