import 'package:flutter/material.dart';

/// Écran d'inscription de l'application
class RegistrationScreen extends StatefulWidget {
  /// Fonction de rappel lors de l'inscription
  final Function onRegister;
  
  /// Fonction de rappel lors du clic sur le bouton de connexion
  final Function onLoginPressed;

  /// Constructeur de l'écran d'inscription
  const RegistrationScreen({
    super.key,
    required this.onRegister,
    required this.onLoginPressed,
  });

  /// Création de l'état du widget
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

/// État de l'écran d'inscription
class _RegistrationScreenState extends State<RegistrationScreen> {
  /// Contrôleur pour le champ nom complet
  final nameCtrl = TextEditingController();
  
  /// Contrôleur pour le champ email
  final emailCtrl = TextEditingController();
  
  /// Contrôleur pour le champ mot de passe
  final passCtrl = TextEditingController();

  /// Construction de l'interface utilisateur de l'écran d'inscription
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre de l'écran
            const Text(
              "Créer un compte",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),

            // Champ de saisie pour le nom complet
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nom complet",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 12),

            // Champ de saisie pour l'email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 12),

            // Champ de saisie pour le mot de passe
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton d'inscription
            ElevatedButton(
              onPressed: () => widget.onRegister(),
              child: const Text("Créer mon compte"),
            ),

            // Bouton pour accéder à la connexion
            TextButton(
              onPressed: () => widget.onLoginPressed(),
              child: const Text("J'ai déjà un compte"),
            ),
          ],
        ),
      ),
    );
  }
}