import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import 'item_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final String categoryApiUrl = 'http://10.0.2.2:9092/api/categories';
  final String menuItemsApiUrl = 'http://10.0.2.2:9092/api/menuItems';

  List<Category> categories = [];
  Map<String, List<MenuItem>> categoryItemsMap = {};
  String selectedCategoryId = '';

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndItems();
  }

  Future<void> fetchCategoriesAndItems() async {
    try {
      // Récupérer les catégories
      final categoryResponse = await http.get(Uri.parse(categoryApiUrl));
      if (categoryResponse.statusCode == 200) {
        List<dynamic> categoryJsonData = json.decode(categoryResponse.body);
        categories = categoryJsonData
            .map((item) => Category.fromJson(item))
            .where((category) => category.etat == "active")
            .toList();

        selectedCategoryId = categories.isNotEmpty ? categories[0].idCategorie : '';
      } else {
        throw Exception('Échec du chargement des catégories');
      }

      // Récupérer les MenuItems
      final itemsResponse = await http.get(Uri.parse(menuItemsApiUrl));
      if (itemsResponse.statusCode == 200) {
        List<dynamic> itemsJsonData = json.decode(itemsResponse.body);
        List<MenuItem> allItems =
        itemsJsonData.map((item) => MenuItem.fromJson(item)).toList();

        // Associer chaque MenuItem à sa catégorie
        for (var category in categories) {
          categoryItemsMap[category.idCategorie] = allItems
              .where((item) => item.categoryId == category.idCategorie)
              .toList();
        }

        setState(() {});
      } else {
        throw Exception('Échec du chargement des MenuItems');
      }
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
    }
  }

  void selectCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  void addToCart(BuildContext context, MenuItem menuItem) {
    Provider.of<CartProvider>(context, listen: false).addItem(
      menuItem.idItem,
      menuItem.nom,
      menuItem.prix,
      1, // Quantité fixe : 1
      menuItem.image ?? '', // URL de l'image
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${menuItem.nom} ajouté au panier avec succès !"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chili's America's Grill"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de navigation des catégories
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => selectCategory(category.idCategorie),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: selectedCategoryId == category.idCategorie
                              ? Colors.red
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Text(
                      category.categorie,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedCategoryId == category.idCategorie
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          // Liste des catégories et articles
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final items = categoryItemsMap[category.idCategorie] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de la catégorie
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        category.categorie,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Liste des articles
                    items.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          "Aucun article disponible dans cette catégorie."),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, itemIndex) {
                        final menuItem = items[itemIndex];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            leading: menuItem.image != null
                                ? Image.network(
                              menuItem.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : Icon(Icons.image_not_supported, size: 60),
                            title: Text(menuItem.nom),
                            subtitle: Text("${menuItem.prix} DT"),
                            trailing: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              color: Colors.green,
                              onPressed: () => addToCart(context, menuItem),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailScreen(menuItem: menuItem),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
