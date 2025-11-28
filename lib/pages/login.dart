import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
  
  /// Indique si l'authentification est en cours
  bool isLoading = false;
  
  /// Message d'erreur
  String errorMessage = '';

  /// Fonction de connexion sécurisée
  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Valider les champs
      if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
        setState(() {
          errorMessage = 'Veuillez remplir tous les champs';
          isLoading = false;
        });
        return;
      }

      // Tenter de connecter l'utilisateur
      final success = await AuthService.loginUser(emailCtrl.text.trim(), passCtrl.text);
      
      if (success) {
        // Connexion réussie
        widget.onLogin();
      } else {
        // Identifiants incorrects
        setState(() {
          errorMessage = 'Email ou mot de passe incorrect';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Une erreur est survenue lors de la connexion';
        isLoading = false;
      });
    }
  }

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

            // Message d'erreur
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),

            // Champ de saisie pour l'email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
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
              onSubmitted: (_) => _handleLogin(), // Connexion avec Entrée
            ),

            const SizedBox(height: 20),
            
            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleLogin,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Se connecter"),
              ),
            ),

            const SizedBox(height: 10),

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

  /// Libération des ressources
  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}