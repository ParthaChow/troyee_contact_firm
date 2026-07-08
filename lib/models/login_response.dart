class LoginResponse {
  final int fieldOfficerId;
  final String fullName;
  final String zone;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;

  LoginResponse({
    required this.fieldOfficerId,
    required this.fullName,
    required this.zone,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      fieldOfficerId: json["fieldOfficerId"],
      fullName: json["fullName"],
      zone: json["zone"],
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      accessTokenExpiresAt:
      DateTime.parse(json["accessTokenExpiresAt"]),
    );
  }
}