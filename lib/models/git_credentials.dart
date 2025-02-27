class GitCredentials {
  final int id;
  final String name;
  final String token;
  final String clientId;
  final String clientSecret;
  final String apiUrl;

  GitCredentials({
    required this.id,
    required this.name,
    required this.token,
    required this.clientId,
    required this.clientSecret,
    required this.apiUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'token': token,
      'client_id': clientId,
      'client_secret': clientSecret,
      'api_url': apiUrl,
    };
  }

  factory GitCredentials.fromMap(Map<String, dynamic> map) {
    return GitCredentials(
      id: map['id'],
      name: map['name'],
      token: map['token'],
      clientId: map['client_id'],
      clientSecret: map['client_secret'],
      apiUrl: map['api_url'],
    );
  }
}