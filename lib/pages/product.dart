import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Écran de gestion des produits
class ProductListScreen extends StatefulWidget {
  /// Constructeur de l'écran de gestion des produits
  const ProductListScreen({super.key});

  /// Création de l'état du widget
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

/// État de l'écran de gestion des produits
class _ProductListScreenState extends State<ProductListScreen> {
  /// Liste des produits
  List<Map<String, dynamic>> products = [];

  /// Contrôleur pour le champ nom du produit
  final nameCtrl = TextEditingController();
  
  /// Contrôleur pour le champ prix du produit
  final priceCtrl = TextEditingController();

  /// Fonction pour ajouter un nouveau produit
  void _addProduct() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ajouter un produit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Prix"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                products.add({
                  "name": nameCtrl.text,
                  "price": priceCtrl.text,
                  "quantity": 1, // Quantité initiale du produit
                });
                nameCtrl.clear();
                priceCtrl.clear();
              });
              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  /// Fonction pour incrémenter la quantité d'un produit
  void _incrementProduct(int index) {
    setState(() {
      products[index]["quantity"] = (products[index]["quantity"] as int) + 1;
    });
  }

  /// Fonction pour décrémenter la quantité d'un produit
  void _decrementProduct(int index) {
    setState(() {
      if (products[index]["quantity"] > 1) {
        products[index]["quantity"] = (products[index]["quantity"] as int) - 1;
      }
    });
  }

  /// Fonction de déconnexion
  Future<void> _handleLogout() async {
    await AuthService.logout();
    // Redirection vers l'écran de connexion se fait automatiquement par ProtectedRoute
  }

  /// Construction de l'interface utilisateur de l'écran de gestion des produits
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application avec bouton de déconnexion
      appBar: AppBar(
        title: const Text("Liste des Produits"),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      // Bouton flottant pour ajouter un produit
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),

      // Contenu principal de l'écran
      body: products.isEmpty
          ? const Center(child: Text("Aucun produit ajouté"))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(products[i]["name"]),
                  subtitle: Row(
                    children: [
                      Text("${products[i]["price"]} F"),
                      const SizedBox(width: 10),
                      Text("Qté: ${products[i]["quantity"]}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton pour décrémenter la quantité
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementProduct(i),
                      ),
                      // Bouton pour incrémenter la quantité
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementProduct(i),
                      ),
                      // Bouton pour supprimer le produit
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => products.removeAt(i));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }
}