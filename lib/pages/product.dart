import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  final Function onLogout;

  const ProductListScreen({
    super.key,
    required this.onLogout,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

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
                  "quantity": 1, // Add quantity field with default value of 1
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

  // Function to increment product quantity
  void _incrementProduct(int index) {
    setState(() {
      products[index]["quantity"] = (products[index]["quantity"] as int) + 1;
    });
  }

  // Function to decrement product quantity
  void _decrementProduct(int index) {
    setState(() {
      if (products[index]["quantity"] > 1) {
        products[index]["quantity"] = (products[index]["quantity"] as int) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Produits"),
        actions: [
          IconButton(
            onPressed: () => widget.onLogout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),

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
                      // Decrement button
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementProduct(i),
                      ),
                      // Increment button
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementProduct(i),
                      ),
                      // Delete button
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
}