import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  ItemDetailScreen({required this.menuItem});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1; // Quantité initiale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuItem.nom,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenu de détail de l'article
            widget.menuItem.image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.menuItem.image!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.image_not_supported,
                size: 250,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.menuItem.nom,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.menuItem.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Prix: ${widget.menuItem.prix} DT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),

            // Gestion de la quantité
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove, color: Colors.red),
                ),
                Text(
                  '$_quantity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: Icon(Icons.add, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Bouton "Add to Cart"
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ajouter l'article au panier avec la quantité sélectionnée
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    widget.menuItem.idItem, // ID de l'article
                    widget.menuItem.nom, // Nom de l'article
                    widget.menuItem.prix, // Prix de l'article
                    _quantity, // Quantité sélectionnée
                    widget.menuItem.image ?? '', // URL de l'image ou chaîne vide
                  );

                  // Afficher un SnackBar pour confirmer l'ajout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.menuItem.nom} ajouté au panier avec $_quantity unités !',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
