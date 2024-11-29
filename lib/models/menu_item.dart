class MenuItem {
  final String idItem; // Identifiant unique de l'article
  final String nom; // Nom de l'article
  final String description; // Description de l'article
  final double prix; // Prix de l'article
  final String? image; // URL de l'image (peut être nul)
  final String categoryId; // Identifiant de la catégorie associée

  // Constructeur
  MenuItem({
    required this.idItem,
    required this.nom,
    required this.description,
    required this.prix,
    this.image,
    required this.categoryId,
  });

  // Factory pour convertir un JSON en une instance de MenuItem
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      idItem: json['idItem'] as String,
      nom: json['nom'] as String,
      description: json['description'] as String,
      prix: (json['prix'] as num).toDouble(), // Conversion en double
      image: json['image'] as String?,
      categoryId: json['categoryId'] as String,
    );
  }

  // Méthode pour convertir une instance de MenuItem en JSON
  Map<String, dynamic> toJson() {
    return {
      'idItem': idItem,
      'nom': nom,
      'description': description,
      'prix': prix,
      'image': image,
      'categoryId': categoryId,
    };
  }

  // Factory pour convertir une liste JSON en une liste de MenuItem
  static List<MenuItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MenuItem.fromJson(json)).toList();
  }
}
