// models/client.dart
class Client {
  final int? id; // Make id nullable to handle potential null values
  final String nom;
  final String email;
  final String? imageClient;

  Client({
    this.id, // Make id nullable here
    required this.nom,
    required this.email,
    this.imageClient,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] != null ? json['id'] as int : null, // Handle null case
      nom: json['nom'] ?? '', // Provide a default value if nom is null
      email: json['email'] ?? '', // Provide a default value if email is null
      imageClient: json['imageClient'], // Image can be nullable
    );
  }
}
