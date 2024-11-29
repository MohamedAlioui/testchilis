import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section d'en-tête du compte avec une image d'avatar et le nom de l'utilisateur
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "johndoe@example.com",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Liste des options de compte
            Expanded(
              child: ListView(
                children: [
                  _buildAccountOption(
                    icon: Icons.person,
                    title: "Profile Settings",
                    onTap: () {
                      // Action pour accéder aux paramètres de profil
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.history,
                    title: "Order History",
                    onTap: () {
                      // Action pour accéder à l'historique des commandes
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.settings,
                    title: "App Settings",
                    onTap: () {
                      // Action pour accéder aux paramètres de l'application
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      // Action pour accéder à l'aide et support
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: () {
                      // Action pour se déconnecter
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
