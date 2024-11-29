class CartItem {
  final String id; // Utilisation d'un String pour correspondre au modèle backend
  final String nom; // Nom de l'article
  final double prix; // Prix de l'article
  final int quantity; // Quantité d'articles dans le panier

  CartItem({
    required this.id,
    required this.nom,
    required this.prix,
    this.quantity = 1, // Quantité par défaut à 1
  });

  // Méthode pour convertir un CartItem en JSON (utile pour la persistance ou l'envoi au backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prix': prix,
      'quantity': quantity,
    };
  }

  // Factory pour créer un CartItem à partir de JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prix: (json['prix'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}
