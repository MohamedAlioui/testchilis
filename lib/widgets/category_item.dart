import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.yellow[100], // Background color for the avatar
          ),
          SizedBox(height: 4),
          Text(
            category.categorie, // Use nomCategorie instead of label
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
