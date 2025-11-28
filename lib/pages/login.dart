import 'package:flutter/material.dart';

/// Écran de connexion de l'application
class LoginScreen extends StatefulWidget {
  /// Fonction de rappel lors de la connexion
  final Function onLogin;
  
  /// Fonction de rappel lors du clic sur le bouton d'inscription
  final Function onRegisterPressed;

  /// Constructeur de l'écran de connexion
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegisterPressed,
  });

  /// Création de l'état du widget
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// État de l'écran de connexion
class _LoginScreenState extends State<LoginScreen> {
  /// Contrôleur pour le champ email
  final emailCtrl = TextEditingController();
  
  /// Contrôleur pour le champ mot de passe
  final passCtrl = TextEditingController();

  /// Construction de l'interface utilisateur de l'écran de connexion
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
              "Connexion",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),

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
            
            // Bouton de connexion
            ElevatedButton(
              onPressed: () => widget.onLogin(),
              child: const Text("Se connecter"),
            ),

            // Bouton pour accéder à l'inscription
            TextButton(
              onPressed: () => widget.onRegisterPressed(),
              child: const Text("Créer un compte"),
            )
          ],
        ),
      ),
    );
  }
}