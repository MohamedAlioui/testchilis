class Category {
  final String idCategorie; // Identifiant unique de la catégorie
  final String categorie;   // Nom de la catégorie
  final String etat;        // État de la catégorie (ex. : "active" ou "inactive")
  final String img;         // URL de l'image associée à la catégorie

  // Constructeur
  Category({
    required this.idCategorie,
    required this.categorie,
    required this.etat,
    required this.img,
  });

  // Factory pour convertir un JSON en une instance de Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategorie: json['idCategorie'] as String,
      categorie: json['categorie'] as String,
      etat: json['etat'] as String,
      img: json['img'] as String,
    );
  }

  // Méthode pour convertir une instance de Category en JSON
  Map<String, dynamic> toJson() {
    return {
      'idCategorie': idCategorie,
      'categorie': categorie,
      'etat': etat,
      'img': img,
    };
  }

  // Factory pour convertir une liste JSON en une liste de Category
  static List<Category> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }
}
